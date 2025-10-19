#!/usr/bin/env bash
set -e

# Promenljive
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_DIR="../dagger-relic"
BUILD_DIR="$PROJECT_DIR/builddir"
OUTPUT_FILE="cppcheck_output_$DATE.xml"

# Pokretanje cppcheck
echo "Pokrecemo cppcheck analizu..."
cppcheck \
    --enable=all \
    --inconclusive \
    --xml \
    --xml-version=2 \
    "$PROJECT_DIR/src" "$PROJECT_DIR/include" 2> "$OUTPUT_FILE"

echo "Analiza zavrsena. Rezultati sacuvani u: $OUTPUT_FILE"
echo "Mozete koristiti cppcheck-gui ili pregledati XML fajl direktno."