#!/bin/bash
set -euo pipefail

# input: the terraform action ('apply' or 'destroy')
tf_action="${1-}"

# validate input parameter tf_action exists
if [[ -z "${tf_action}" ]]; then
  echo "Error: Missing terraform action. Expected 'apply' or 'destroy'." >&2
  exit 1
fi

# validate tf_action value
if [[ "${tf_action}" != "apply" && "${tf_action}" != "destroy" ]]; then
  echo "Error: Invalid terraform action '${tf_action}'. Expected 'apply' or 'destroy'." >&2
  exit 1
fi

# constant for the terraform output file's path
TF_OUT="./tf${tf_action}.out"

# check if the terraform output file exists
if [[ ! -f "${TF_OUT}" ]]; then
  echo "Error: Terraform apply/destroy output file '${TF_OUT}' not found." >&2
  exit 1
fi

#
# functions
#

get_unit_summary_content() {
  grep 'STDOUT' | grep -E "${tf_action^} complete" || true
}

remove_color_codes() {
  sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g'
}

# extract unit name from a line like "[unit-name]    Apply complete! Resources: 2 added, 0 changed, 1 destroyed."
# awk command breakdown:
#   -F'[][]'             : set field separator to either '[' or ']', so that the unit name is in field 2
#   '{print "[" $2 "]"}' : print the unit name wrapped in brackets
#
# note1: the brackets are included in the output to match the format used elsewhere
# note2: field 1 is the color codes set by terragrunt
get_unit_name() {
  awk -F'[][]' '{print "[" $2 "]"}'
}

# even though sort --ignore-nonprinting is a thing, it does not work as documented on github's ubuntu-24.04 runner (as of 2026-01)
# so here's a function using awk, sort, and cut that ignores color codes for sorting but maintains them in the output
# awk command breakdown:
#   x=$0                         : save original line with colors
#   gsub(/\x1b\[[0-9;]*m/,"")    : strip color codes from $0
#   print $0 "\t" x              : print stripped text, TAB, original line
#   sort                         : sort by stripped text (first field)
#   cut -f2-                     : extract only the original colored line
sort_on_text_not_color_codes() {
  awk '{x=$0; gsub(/\x1b\[[0-9;]*m/,""); print $0 "\t" x}' | sort | cut -f2-
}

echo_expandable_group() {
  local title="$1"
  local content="$2"

  echo -e "::group::${title}"
  echo -e "${content}"
  echo -e "::endgroup::"
}

echo_as_diff() {
  local content="$1"

  echo -e '```diff'
  echo -e "${content}"
  echo -e '```'
}

move_delimiter() {
  sed 's/|\x1b\[0m/\x1b[0m|/g'  # move delimiter after reset code, all matches
}

# This function processes terragrunt apply/destroy output lines to extract and format summaries.
#
# Input Format:
#   00:00:00.000 STDOUT [logs] terraform: Apply complete! Resources: 2 added, 0 changed, 1 destroyed.
#
# Processing Logic:
#   - Extract unit name from field 3 (already in [brackets])
#   - Remove fields 1-4: timestamp, "STDOUT", unit name, "terraform:"
#   - Format: unit | remaining text
#
# awk command breakdown:
#   '{unit=$3;                  : get the unit name from the third field (including brackets)
#   $1=$2=$3=$4="";             : remove first four fields (timestamp, "STDOUT", unit name, and "terraform:")
#   sub(/^[ \t]+/, "")          : trim leading whitespace left over from removed fields
#                                 - /^[ \t]+/ matches one or more spaces/tabs at the start
#                                 - "" replaces them with nothing
#   print unit "|" $0           : output unit name, pipe separator, and cleaned remaining text
#
format_units() {
  awk '{unit=$3; $1=$2=$3=$4=""; sub(/^[ \t]+/, ""); print unit "|" $0}' | \
  move_delimiter | \
  column -t -s "|" |  # align columns, delimiter is '|'
  sort_on_text_not_color_codes || true
}

colorize_with_regex() {
  local regex=$1
  local color=$2
  sed -E "s/($regex)/\x1b[${color}m\1\x1b[0m/g"  # add color code around regex, all matches
}

colorize_unit_summary() {
  colorize_with_regex '[1-9][0-9]* added' '32' |    # for lines with non-zero add count, colorize 'added' in green
  colorize_with_regex '[1-9][0-9]* changed' '33' |  # for lines with non-zero change count, colorize 'changed' in yellow
  colorize_with_regex '[1-9][0-9]* destroyed' '31'  # for lines with non-zero destroy count, colorize 'destroyed' in red
}

build_unit_summary() {
  local color_mode="$1"

  if [ "$color_mode" = 'with_color' ]; then
    get_unit_summary_content | \
    format_units | \
    colorize_unit_summary
  else
    get_unit_summary_content | \
    format_units
  fi
}

render_output_for_github_actions_log() {

  # iterate over each line in unit_summary_without_color (so the color codes don't get in the way)
  # compile the raw text per unit
  echo -e "\nraw text per unit:"
  while IFS= read -r line; do

    # get unit's name from line
    unit_name=$(echo "$line" | get_unit_name)

    # get unit's summary line with color
    unit_summary_line_with_color=$(echo "$unit_summary_with_color" | grep -F "$unit_name" || true)

    # get unit's raw text with color
    unit_raw_text_with_color=$(echo "$raw_text_with_color" | grep -F "$unit_name" || true)

    # echo expandable group for unit's raw text
    echo_expandable_group "${unit_summary_line_with_color}" "${unit_raw_text_with_color}"

  done <<< "$unit_summary_without_color"

  echo -e "\ndiagnostics:"
  echo_expandable_group 'raw text with color' "$raw_text_with_color"
  echo_expandable_group 'raw text without color' "$raw_text_without_color"
  echo_expandable_group 'unit summary with color' "$unit_summary_with_color"
  echo_expandable_group 'unit summary without color' "$unit_summary_without_color"
  echo -e "\n"
}

render_output_for_github_step_summary() {
  echo_as_diff "$unit_summary_without_color"
}

#
# main
#

# get raw text from the out file
raw_text_with_color=$(cat "$TF_OUT")
raw_text_without_color=$(echo "$raw_text_with_color" | remove_color_codes)

# build unit summary
unit_summary_with_color=$(echo "$raw_text_with_color" | build_unit_summary 'with_color')
unit_summary_without_color=$(echo "$raw_text_without_color" | build_unit_summary 'without_color')

# render output
rendered_output_for_github_actions_log=$(render_output_for_github_actions_log)
rendered_output_for_github_step_summary=$(render_output_for_github_step_summary)

# publish/echo output
echo "$rendered_output_for_github_actions_log"
echo "$rendered_output_for_github_step_summary" >> "$GITHUB_STEP_SUMMARY"

# annotate
echo -e "\n::notice::${tf_action^} summary.\n"
