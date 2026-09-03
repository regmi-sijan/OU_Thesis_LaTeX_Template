#!/usr/bin/env bash

# Scans an "input" folder of PDFs, checks each one for non-embedded fonts,
# and writes fixed copies to an "output" folder.
#
# Usage:
#   ./FixImages.sh                # uses ./input as input, ./fixed_images as output
#   ./FixImages.sh <input_dir>              # custom input, default output
#   ./FixImages.sh <input_dir> <output_dir> # custom input and output

set -euo pipefail

# Resolve paths relative to this script's own location, not the caller's
# current directory, so it behaves the same no matter where it's run from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IN_DIR="${1:-$SCRIPT_DIR/input}"
OUT_DIR="${2:-$SCRIPT_DIR/fixed_images}"

# Make sure the tools this script depends on are actually available before
# doing any work.
for cmd in pdffonts gs; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command '$cmd' not found on PATH." >&2
        echo "Install poppler-utils (for pdffonts) and Ghostscript (for gs)." >&2
        exit 1
    fi
done

if [ ! -d "$IN_DIR" ]; then
    echo "Error: input folder not found: $IN_DIR" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

shopt -s nullglob
pdfs=("$IN_DIR"/*.pdf)

if [ ${#pdfs[@]} -eq 0 ]; then
    echo "No PDF files found in: $IN_DIR"
    exit 0
fi

echo "Scanning ${#pdfs[@]} PDF(s) in: $IN_DIR"
echo "Output folder: $OUT_DIR"
echo "----------------------------------------"

fixed_count=0
skipped_count=0

for f in "${pdfs[@]}"; do
    name="$(basename "$f")"

    # A file needs fixing if pdffonts lists ANY font with "no" in the
    # embedded column. Skip the two header lines when checking.
    if pdffonts "$f" | tail -n +3 | awk '{print $(NF-2)}' | grep -q "^no$"; then
        echo "FIX NEEDED : $name"
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
           -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 \
           -sOutputFile="$OUT_DIR/$name" \
           -c "<< /NeverEmbed [ ] >> setdistillerparams" \
           -f "$f" > /dev/null 2>&1
        fixed_count=$((fixed_count + 1))
    else
        echo "OK, skipped: $name"
        skipped_count=$((skipped_count + 1))
    fi
done

echo "----------------------------------------"
echo "Done. Fixed: $fixed_count   Already OK: $skipped_count"
echo "Fixed files are in: $OUT_DIR"
echo ""
echo "Spot-check a few visually, then replace the originals with the"
echo "fixed versions (or update your \\includegraphics paths) once happy."
