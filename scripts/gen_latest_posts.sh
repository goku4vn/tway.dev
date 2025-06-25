#!/bin/bash

set -e

POSTS_DIR="posts"
OUTPUT="demo/index.generated.md"
TEMPLATE="demo/index.md"
MAX_POSTS=5
TMP_LATEST="/tmp/latest_posts_list.txt"

> "$TMP_LATEST"

# Tìm tất cả file, loại trừ index.md, trích xuất ngày từ path bằng sed, sort theo ngày và tên file giảm dần, lấy N bài mới nhất
find "$POSTS_DIR" -type f -name "*.md" | grep -v 'posts/index.md$' | grep -v 'posts/index.generated.md$' | while read -r file; do
  date_path=$(echo "$file" | sed -n 's/.*\([0-9][0-9][0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]\).*/\1/p')
  if [ -n "$date_path" ]; then
    sort_date=$(echo "$date_path" | sed 's#/#-#g')
  else
    sort_date="0000-00-00"
  fi
  printf '%s\t%s\n' "$sort_date" "$file"
done | sort -r -k1,1 -k2,2 | head -n $MAX_POSTS | cut -f2- | while read -r file; do
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
  echo "- $prefix[$title]($link)" >> "$TMP_LATEST"
done

echo "\n[View all posts...](/posts/)" >> "$TMP_LATEST"

awk -v posts_file="$TMP_LATEST" '
  /<!--LATEST_POSTS-->/ {
    while ((getline line < posts_file) > 0) print line;
    close(posts_file);
    next
  }
  { print }
' "$TEMPLATE" > "$OUTPUT" 