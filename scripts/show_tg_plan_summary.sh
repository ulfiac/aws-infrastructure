#!/bin/bash
set -euo pipefail

# input: the terraform action ('plan' or 'plan destroy')
tf_action="${1-}"

# validate input parameter tf_action exists
if [[ -z "${tf_action}" ]]; then
  echo "Error: Missing terraform action. Expected 'plan' or 'plan destroy'." >&2
  exit 1
fi

# validate tf_action value
if [[ "${tf_action}" != "plan" && "${tf_action}" != "plan destroy" ]]; then
  echo "Error: invalid tf_action '${tf_action}'. Expected 'plan' or 'plan destroy'." >&2
  exit 1
fi

# constant for the terraform output binary filename
TFPLAN_BINARY='tfplan.binary'

#
# functions
#

get_unit_summary_content() {
  grep 'STDOUT' | grep -E '(No changes|Plan:)' || true
}

get_resource_summary_content() {
  grep 'STDOUT' | grep '#' | grep -v -E "(unchanged|depends on a resource or a module with changes pending|config refers to values not yet known|is not in configuration|forces replacement)" || true
}

# extract unit name from a line like "[unit-name]    Plan: 2 to add, 0 to change, 1 to destroy."
# awk command breakdown:
#   -F'[][]'             : set field separator to either '[' or ']', so that the unit name is in field 2
#   '{print "[" $2 "]"}' : print the unit name wrapped in brackets
#
# note1: the brackets are included in the output to match the format used elsewhere
# note2: field 1 is the color codes set by terragrunt
get_unit_name() {
  awk -F'[][]' '{print "[" $2 "]"}'
}

# even though sort --ignore-nonprinting is a thing, it does not work as documented on github's ubuntu-latest runner (as of 2026-01)
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

echo_collapsible_section() {
  local title="$1"
  local content="$2"

  echo -e "<details>"
  echo -e "<summary>${title}</summary>\n"
  echo -e "${content}"
  echo -e "</details>"
}

echo_collapsible_section_as_diff() {
  local title="$1"
  local content="$2"

  echo -e "<details>"
  echo -e "<summary>${title}</summary>\n"
  echo -e '```diff'
  echo -e "${content}"
  echo -e '```'
  echo -e "</details>"
}

echo_as_diff() {
  local content="$1"

  echo -e '```diff'
  echo -e "$content"
  echo -e '```'
}

remove_reset() {
  sed 's/\x1b\[0m//g'  # replace reset code with nothing, all matches
}

replace_bold_with_reset() {
  sed 's/\x1b\[1m/\x1b[0m/g'  # replace bold code with reset code, all matches
}

move_delimiter() {
  sed 's/|\x1b\[0m/\x1b[0m|/g'  # move delimiter after reset code, all matches
}

add_reset_after_pattern() {
  local pattern=$1
  sed "s/\($pattern\)/\1\x1b[0m\x1b[0m/g"  # add 2 reset codes after pattern, all matches
}

# This function processes terragrunt plan output lines to extract and format plan summaries.
#
# Input Format:
#   00:00:00.000 STDOUT [logs] terraform: Plan: 2 to add, 0 to change, 1 to destroy.
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
  remove_reset | \
  replace_bold_with_reset | \
  move_delimiter | \
  column -t -s "|" |  # align columns, delimiter is '|'
  sort_on_text_not_color_codes || true
}

# This function processes terragrunt plan output lines to extract and format resource change summaries.
#
# awk command breakdown:
#   unit=$1;                          : get the unit name from the third field (including brackets)
#   resource=$3;                      : get the resource name from the seventh field
#   $1=$2=$3="";                      : remove first seven fields (timestamp, "STDOUT", unit name, "terraform:", "#", and resource)
#   sub(/^[ \t]+/, "")                : trim leading whitespace left over from removed fields
#                                       - /^[ \t]+/ matches one or more spaces/tabs at the start
#                                       - "" replaces them with nothing
#   print unit "|" resource "|" $0}'  : output unit name with color reset, pipe separator, resource name, another pipe, and cleaned remaining text
#
format_resources() {
  awk '{unit=$1; resource=$3; $1=$2=$3=""; sub(/^[ \t]+/, ""); print unit "|" resource "|" $0}' | \
  column -t -s "|" |  # align columns, delimiter is '|'
  sort_on_text_not_color_codes || true
}

colorize() {
  local pattern=$1
  local color=$2
  sed "s/$pattern/\x1b[${color}m$pattern\x1b[0m/g"  # add color code around pattern, all matches
}

colorize_and_bold() {
  local pattern=$1
  local color=$2
  sed "s/$pattern/\x1b[1m\x1b[${color}m$pattern\x1b[0m\x1b[0m/g"  # add bold and color code around pattern, all matches
}

colorize_with_regex() {
  local regex=$1
  local color=$2
  sed -E "s/($regex)/\x1b[${color}m\1\x1b[0m/g"  # add color code around regex, all matches
}

colorize_and_bold_with_regex() {
  local regex=$1
  local color=$2
  sed -E "s/($regex)/\x1b[1m\x1b[${color}m\1\x1b[0m\x1b[0m/g"  # add bold and color code around regex, all matches
}

colorize_unit_summary() {
  colorize '- ' '31' |                                # red
  colorize_with_regex '[1-9][0-9]* to add' '32' |     # for lines with non-zero add count, colorize 'add' in green
  colorize_with_regex '[1-9][0-9]* to change' '33' |  # for lines with non-zero change count, colorize 'change' in yellow
  colorize_with_regex '[1-9][0-9]* to destroy' '31'   # for lines with non-zero destroy count, colorize 'destroy' in red
}

colorize_resource_summary() {
  add_reset_after_pattern 'destroyed' |  # already colorized by terragrunt; reset removed in format_units function; adding it back here
  colorize 'created' '32' |              # green
  colorize 'updated in-place' '33' |     # yellow
  colorize 'replaced' '35' |             # magenta
  colorize '+ ' '32' |                   # green
  colorize '- ' '31' |                   # red
  colorize '~ ' '33'                     # yellow
}

diffify_unit_summary() {
  sed 's/^/  /' |                          # add 2 spaces at start of every line
  sed '/[1-9][0-9]* to destroy/s/^  /- /'  # for lines with non-zero destroy count, replace leading spaces with '- '
}

diffify_resource_summary() {
  sed 's/^/  /' |                      # add 2 spaces at start of every line
  sed '/created/s/^  /+ /' |           # if the line contains 'created', replace the 2 spaces with '+ '
  sed '/destroyed/s/^  /- /' |         # if the line contains 'destroyed', replace the 2 spaces with '- '
  sed '/updated in-place/s/^  /~ /' |  # if the line contains 'updated in-place', replace the 2 spaces with '~ '
  sed '/replaced/s/^  /- /'            # if the line contains 'replaced', replace the 2 spaces with '- '
}

build_unit_summary() {
  local color_mode="$1"

  if [ "$color_mode" = 'with_color' ]; then
    get_unit_summary_content | \
    format_units | \
    diffify_unit_summary | \
    colorize_unit_summary
  else
    get_unit_summary_content | \
    format_units | \
    diffify_unit_summary
  fi
}

build_resource_summary() {
  local color_mode="$1"

  if [ "$color_mode" = 'with_color' ]; then
    get_resource_summary_content | \
    format_units | \
    format_resources | \
    diffify_resource_summary | \
    colorize_resource_summary
  else
    get_resource_summary_content | \
    format_units | \
    format_resources | \
    diffify_resource_summary
  fi
}

render_output_for_github_actions_log() {

  # iterate over each line in unit_summary_without_color (so the color codes don't get in the way)
  # compile a summary per unit
  echo -e "\nsummary per unit:"
  while IFS= read -r line; do

    # get unit's name from line
    unit_name=$(echo "$line" | get_unit_name)

    # get unit's summary line with color
    unit_summary_line_with_color=$(echo "$unit_summary_with_color" | grep -F "$unit_name" || true)

    # get unit's resources lines with color
    resources_lines_with_color=$(echo "$resource_summary_with_color" | grep -F "$unit_name" || true)

    # echo expandable group for unit
    echo_expandable_group "${unit_summary_line_with_color}" "${resources_lines_with_color}"

  done <<< "$unit_summary_without_color"

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
  echo_expandable_group 'resource summary with color' "$resource_summary_with_color"
  echo_expandable_group 'resource summary without color' "$resource_summary_without_color"
  echo -e "\n"
}

render_output_for_github_step_summary() {
  echo_as_diff "$unit_summary_without_color"
  echo_collapsible_section_as_diff "Resource summary:" "$resource_summary_without_color"
}

#
# main
#

# get raw text from terragrunt show
raw_text_with_color=$(terragrunt show "$TFPLAN_BINARY" 2>&1)
raw_text_without_color=$(terragrunt show -no-color "$TFPLAN_BINARY" 2>&1)

# build unit summary
unit_summary_with_color=$(echo "$raw_text_with_color" | build_unit_summary 'with_color')
unit_summary_without_color=$(echo "$raw_text_without_color" | build_unit_summary 'without_color')

# build resource summary
resource_summary_with_color=$(echo "$raw_text_with_color" | build_resource_summary 'with_color')
resource_summary_without_color=$(echo "$raw_text_without_color" | build_resource_summary 'without_color')

# render output
rendered_output_for_github_actions_log=$(render_output_for_github_actions_log)
rendered_output_for_github_step_summary=$(render_output_for_github_step_summary)

# publish/echo output
echo "$rendered_output_for_github_actions_log"
echo "$rendered_output_for_github_step_summary" >> "$GITHUB_STEP_SUMMARY"

# annotate
echo -e "\n::notice::${tf_action^} summary.\n"
