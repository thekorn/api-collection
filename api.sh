#!/usr/bin/env bash

BASEDIR=~/devel/github.com/thekorn/api-collection

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd -p -t d -d 3 --min-depth 2 "$BASEDIR" | sed "s;$HOME;~;" | fzf)
fi

if [[ -z $selected ]]; then
    echo "No directory selected"
    exit 0
fi

selected=$(echo $selected | sed "s;~;$HOME;")

if [ ! -d "$selected" ]; then
  echo "$selected does not exist."
  exit 1
fi

if [ ! -f "$selected/slumber.yml" ]; then
  echo "$selected is not a slumber directory."
  exit 1
fi

echo "Selected: $selected"

if [ -f "$selected/.env" ]; then
  op run --env-file="$selected/.env" -- slumber --file "$selected/slumber.yml"
else
  slumber --file "$selected/slumber.yml"
fi
