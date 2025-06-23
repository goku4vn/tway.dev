#!/bin/bash

set -e

POSTS_DIR="posts"
OUTPUT="demo/index.generated.md"
TEMPLATE="demo/index.md"
MAX_POSTS=5

LATEST_POSTS=""
# Find all markdown files, exclude index.md, sort reverse chronologically by path, and take the top N
for file in $(find "$POSTS_DIR" -type f -name "*.md" | grep -v 'posts/index.md$' | sort -r | head -n $MAX_POSTS); do
  # The link should be relative to the root, e.g. posts/topic/post.html
  link=$(echo "$file" | sed 's/\.md$/.html/g')

  # Get title and subtitle from YAML frontmatter
  title=$(grep -m1 '^title:' "$file" | sed 's/^title:[ ]*//' || true)
  subtitle=$(grep -m1 '^subtitle:' "$file" | sed 's/^subtitle:[ ]*//' || true)

  # Fallback to filename if title is not found
  if [ -z "$title" ]; then
    title=$(basename "$file" .md)
  fi

  if [ -n "$subtitle" ]; then
    LATEST_POSTS+="- [$title]($link) - $subtitle\\n"
  else
    LATEST_POSTS+="- [$title]($link)\\n"
  fi
done

awk -v posts="$LATEST_POSTS" '
  /<!--LATEST_POSTS-->/ { print posts; next }
  { print }
' "$TEMPLATE" > "$OUTPUT" 