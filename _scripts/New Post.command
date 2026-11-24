#!/bin/bash
# Double-click to start a new blog post. Opens in Terminal, asks for a title,
# creates the post and opens it for writing, then offers to publish it.

cd "$(dirname "$0")" || exit 1

echo "New blog post"
echo "-------------"
title=""
while [ -z "$title" ]; do
  read -r -p "Title: " title
done
echo

./new-post "$title" || { read -r -p "Press Enter to close."; exit 1; }

echo
echo "Write your post and save it. Then come back here and:"
echo "  - press Enter to publish it, or"
echo "  - close this window to publish later (run _scripts/publish)."
read -r
./publish
echo
read -r -p "Press Enter to close."
