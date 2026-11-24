#!/bin/bash
# Double-click to add photos to a blog post. Pick the post, pick the photos;
# they're resized and stripped of location data, and the Markdown to paste
# into the post is copied to the clipboard. Then offers to publish.

cd "$(dirname "$0")" || exit 1

finish() {
  echo
  read -r -p "Press Enter to close."
  exit "${1:-0}"
}

# Newest posts first, as filenames without .md (e.g. 2026-11-24-my-post)
posts=()
while IFS= read -r f; do
  posts+=("$(basename "$f" .md)")
done < <(ls -1 ../_posts/*.md 2>/dev/null | sort -r)

if [ ${#posts[@]} -eq 0 ]; then
  echo "No posts found. Make one first with New Post.command."
  finish 1
fi

post="$(osascript - "${posts[@]}" <<'APPLESCRIPT'
on run argv
  activate
  set picked to choose from list argv with title "Add Post Photo" with prompt "Which post are the photos for?" default items {item 1 of argv} OK button name "Next"
  if picked is false then return ""
  return item 1 of picked
end run
APPLESCRIPT
)"
if [ -z "$post" ]; then
  echo "Cancelled."
  finish 0
fi

photos=()
while IFS= read -r f; do
  [ -n "$f" ] && photos+=("$f")
done < <(osascript <<'APPLESCRIPT' 2>/dev/null
activate
set picked to choose file with prompt "Choose photos for the post (hold Command to pick several)" of type {"public.image"} default location (path to pictures folder) with multiple selections allowed
set out to ""
repeat with f in picked
  set out to out & POSIX path of f & linefeed
end repeat
return out
APPLESCRIPT
)

if [ ${#photos[@]} -eq 0 ]; then
  echo "No photos chosen. Cancelled."
  finish 0
fi

echo "Adding ${#photos[@]} photo(s) to $post"
echo
./add-photo --post "$post" --copy "${photos[@]}" || finish 1

echo
echo "Opening the post. Paste (⌘V) where you want the photos, then save."
open "../_posts/$post.md" 2>/dev/null || open -t "../_posts/$post.md"

echo
echo "When you've saved the post, come back here and:"
echo "  - press Enter to publish it, or"
echo "  - close this window to publish later (run _scripts/publish)."
read -r
./publish
finish 0
