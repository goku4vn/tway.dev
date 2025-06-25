#!/bin/bash

set -e

POSTS_DIR="posts"
TEMPLATE="posts/index.md"
OUTPUT="posts/index.generated.md"

ALL_POSTS=""
# Using find to recursively get all posts, sorting them reverse chronologically by path
# Assumes YYYY/MM/DD structure for sorting.
for file in $(find "$POSTS_DIR" -type f -name "*.md" | grep -v 'posts/index.md$' | sort -r); do
  # Create a link relative to the /posts/ page.
  # from posts/a/b/c.md -> a/b/c.html
  link=$(echo "$file" | sed -e 's,^posts/,,g' -e 's/\.md$/.html/g')
  
  # Extract date from path like YYYY/MM/DD
  date_path=$(echo "$file" | grep -o '[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}' || true)
  if [ -n "$date_path" ]; then
    formatted_date=$(echo "$date_path" | sed 's/\//-/g')
    prefix="$formatted_date: "
  else
    prefix=""
  fi
  
  title=$(grep -m1 '^title:' "$file" | sed 's/^title:[ ]*//' || true)
  
  # Loại bỏ dấu quote ở đầu/cuối nếu có
  title=$(echo "$title" | sed 's/^"//;s/"$//')
  
  # Fallback to filename if title is not found
  if [ -z "$title" ]; then
    title=$(basename "$file" .md)
  fi
  
  ALL_POSTS+="- $prefix[$title]($link)\\n"
done

# Using awk to replace the placeholder
awk -v posts="$ALL_POSTS" '
  /<!-- ALL_POSTS -->/ { print posts; next }
  { print }
' "$TEMPLATE" > "$OUTPUT" 