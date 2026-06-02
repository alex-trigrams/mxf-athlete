#!/bin/bash
# Drop the raw hero video into videos/raw/ then run this script.
# Outputs videos/hero.mp4 (H.264, no audio, web-optimised).
# The video loops via the HTML <video loop> attribute — no re-encoding needed.

set -e

SRC=$(find videos/raw -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.MP4" -o -name "*.mov" -o -name "*.MOV" \) | head -1)

if [ -z "$SRC" ]; then
  echo "No video found in videos/raw/. Drop an mp4 or mov file there first."
  exit 1
fi

echo "Source: $SRC"
echo "Compressing → videos/hero.mp4 ..."

ffmpeg -y -i "$SRC" \
  -vcodec libx264 \
  -crf 26 \
  -preset slow \
  -profile:v baseline \
  -level 3.1 \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -an \
  videos/hero.mp4

SIZE=$(du -sh videos/hero.mp4 | cut -f1)
echo ""
echo "Done → videos/hero.mp4 ($SIZE)"
echo "Run: open http://localhost:8080 to verify, then commit."
