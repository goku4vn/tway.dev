#!/bin/bash

set -e

POSTS_DIR="posts"
OUTPUT="demo/index.generated.md"
TEMPLATE="demo/index.md"
MAX_POSTS=5

LATEST_POSTS=""
# Tìm tất cả file, loại trừ index.md, trích xuất ngày từ path, sort theo ngày giảm dần, lấy N bài mới nhất
find "$POSTS_DIR" -type f -name "*.md" | grep -v 'posts/index.md$' | grep -v 'posts/index.generated.md$' | \
while read -r file; do
  date_path=$(echo "$file" | grep -o '[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}')
  if [ -n "$date_path" ]; then
    sort_date=$(echo "$date_path" | sed 's#/#-#g')
  else
    sort_date="0000-00-00"
  fi
  echo -e "$sort_date\t$file"
done | sort -r | cut -f2- | head -n $MAX_POSTS | while read -r file; do
  link=$(echo "$file" | sed 's/\.md$/.html/g')
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
  LATEST_POSTS+="- $prefix[$title]($link)\\n"
done

if [ -n "$LATEST_POSTS" ]; then
  LATEST_POSTS+="\\n[View all posts...](/posts/)"
fi

awk -v posts="$LATEST_POSTS" '
  /<!--LATEST_POSTS-->/ { print posts; next }
  { print }
' "$TEMPLATE" > "$OUTPUT" 