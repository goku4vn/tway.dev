#!/bin/bash

POSTS_DIR="posts"
OUTPUT="demo/index.generated.md"
TEMPLATE="demo/index.md"

LATEST_POSTS=""
for file in $(ls -t $POSTS_DIR/*.md); do
  slug=$(basename "$file" .md)
  # Lấy title và subtitle từ YAML frontmatter
  title=$(grep -m1 '^title:' "$file" | sed 's/^title:[ ]*//')
  subtitle=$(grep -m1 '^subtitle:' "$file" | sed 's/^subtitle:[ ]*//')
  [ -z "$title" ] && title="$slug"
  if [ -n "$subtitle" ]; then
    LATEST_POSTS+="- [$title](/posts/$slug) - $subtitle\\n"
  else
    LATEST_POSTS+="- [$title](/posts/$slug)\\n"
  fi
done

awk -v posts="$LATEST_POSTS" '
  /<!--LATEST_POSTS-->/ { print posts; next }
  { print }
' "$TEMPLATE" > "$OUTPUT" 