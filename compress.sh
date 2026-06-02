#!/bin/bash
# Drop raw images into images/raw/bio/ or images/raw/testimonials/
# Run this script — compressed output lands in images/bio/ or images/testimonials/
# Then run: open index.html to verify before committing.

set -e

BIO_IN="images/raw/bio"
BIO_OUT="images/bio"
TEST_IN="images/raw/testimonials"
TEST_OUT="images/testimonials"

process() {
  local src="$1" out_dir="$2" max_px="$3" quality="$4"
  local ext="${src##*.}"
  local base=$(basename "$src" ".$ext")
  local dest="$out_dir/$base.jpg"

  echo "  → $base.$ext"
  sips -s format jpeg -s formatOptions "$quality" --resampleHeightWidthMax "$max_px" "$src" --out "$dest" > /dev/null 2>&1
}

echo "[ bio ] processing..."
find "$BIO_IN" -maxdepth 1 -type f | while read -r f; do
  process "$f" "$BIO_OUT" 1400 85
done

echo "[ testimonials ] processing..."
find "$TEST_IN" -maxdepth 1 -type f | while read -r f; do
  process "$f" "$TEST_OUT" 400 80
done

echo ""
echo "Done. Check images/bio/ and images/testimonials/ then update index.html."
