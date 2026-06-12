#!/bin/bash

echo -e "Dumping input context...\n"

echo "::group::inputs context:"
echo "$CONTEXT_INPUTS" | jq -S .
echo "::endgroup::"
