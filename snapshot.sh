#!/bin/sh
set -e

# Base snapshots directory
BASE_DIR="/data/html/snapshots"
mkdir -p "$BASE_DIR"

# Default to 15s if not set
INTERVAL=${SNAPSHOT_INTERVAL:-15}

while true; do
  # Create per-day subdirectory (YYYYMMDD)
  DATE_DIR=$(date +"%Y%m%d")
  DEST_DIR="$BASE_DIR/$DATE_DIR"
  mkdir -p "$DEST_DIR"

  # Generate timestamped filename
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

  # Capture a single frame into the daily folder
  ffmpeg -y \
    -i "http://localhost/hls/${STREAM_KEY}/index.m3u8" \
    -frames:v 1 -q:v 2 "$DEST_DIR/${TIMESTAMP}.jpg"

  # Update the always-current snapshot
  cp "$DEST_DIR/${TIMESTAMP}.jpg" "/data/html/snapshot.jpg"

  # Wait before the next snapshot
  sleep "$INTERVAL"

done
