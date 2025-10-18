#!/usr/bin/env bash
set -e

# Promenljive
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_DIR="../../dagger-relic"
BUILD_DIR="$PROJECT_DIR/builddir"
OUTPUT_FILE="$(pwd)/massif_output_$DATE.out"
EXECUTABLE="builddir/dagger"
TIMEOUT_DURATION=10

# Ako executable ne postoji, builduj projekat
if [ ! -f "$PROJECT_DIR/$EXECUTABLE" ]; then
    echo "Nema detektovanog executable fajla, buildujemo projekat..."
    meson setup "$BUILD_DIR" "$PROJECT_DIR" >/dev/null
    meson compile -C "$BUILD_DIR" >/dev/null
else
    echo "Build vec postoji, preskacemo ponovno buildovanje."
fi

if [ ! -f "$PROJECT_DIR/$EXECUTABLE" ]; then
    echo "Ne postoji executable fajl: $PROJECT_DIR/$EXECUTABLE"
    exit 1
fi

# Pokretanje Valgrind Massif
echo "Pokrecemo Valgrind Massif..."
cd "$PROJECT_DIR"
timeout -s INT "$TIMEOUT_DURATION"s valgrind \
    --tool=massif \
    --time-unit=ms \
    --massif-out-file="$OUTPUT_FILE" \
    "$EXECUTABLE"

echo "Analiza zavrsena. Rezultati sacuvani u: $OUTPUT_FILE"
echo "Mozete koristiti ms_print ili massif-visualizer da pregledate rezultat."
