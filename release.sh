#!/usr/bin/env bash
# Đẩy bộ cài lên GitHub Releases.
# Dùng: ./release.sh v0.2 path/KufCad-v0.2-Windows-x64.zip path/KufCad-v0.2-macOS-universal.zip [notes.md]
set -euo pipefail
TAG="$1"; shift
NOTES=""
FILES=()
for f in "$@"; do
  case "$f" in *.md) NOTES="$f" ;; *) FILES+=("$f") ;; esac
done
[ ${#FILES[@]} -gt 0 ] || { echo "Thiếu file bộ cài"; exit 1; }
SUMS="$(mktemp -d)/SHA256SUMS.txt"
(for f in "${FILES[@]}"; do (cd "$(dirname "$f")" && shasum -a 256 "$(basename "$f")"); done) > "$SUMS"
if [ -n "$NOTES" ]; then
  gh release create "$TAG" "${FILES[@]}" "$SUMS" --title "KufCad $TAG" --notes-file "$NOTES"
else
  gh release create "$TAG" "${FILES[@]}" "$SUMS" --title "KufCad $TAG" --generate-notes
fi
