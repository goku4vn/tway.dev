#!/bin/bash

set -e

POSTS_DIR="posts"
TEMPLATE="posts/index.md"
OUTPUT="posts/index.generated.md"

ALL_POSTS=""

# Tìm tất cả file, loại trừ index.md, trích xuất ngày từ path, sort theo ngày giảm dần
find "$POSTS_DIR" -type f -name "*.md" | grep -v 'posts/index.md$' | \
while read -r file; do
  # Trích xuất ngày từ path (YYYY/MM/DD)
  date_path=$(echo "$file" | grep -o '[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}')
  if [ -n "$date_path" ]; then
    sort_date=$(echo "$date_path" | sed 's#/#-#g')
  else
    sort_date="0000-00-00"
  fi
  echo -e "$sort_date\t$file"
done | sort -r | cut -f2- | while read -r file; do
  link=$(echo "$file" | sed -e 's,^posts/,,g' -e 's/\.md$/.html/g')
  date_path=$(echo "$file" | grep -o '[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}' || true)
  if [ -n "$date_path" ]; then
    formatted_date=$(echo "$date_path" | sed 's/\//-/g')
    prefix="$formatted_date: "
  else
    prefix=""
  fi
  title=$(grep -m1 '^title:' "$file" | sed 's/^title:[ ]*//' || true)
  title=$(echo "$title" | sed 's/^"//;s/"$//')
  if [ -z "$title" ]; then
    title=$(basename "$file" .md)
  fi
  ALL_POSTS+="- $prefix[$title]($link)\\n"
done

awk -v posts="$ALL_POSTS" '
  /<!-- ALL_POSTS -->/ { print posts; next }
  { print }
' "$TEMPLATE" > "$OUTPUT" 