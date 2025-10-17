#!/usr/bin/env bash
set -e

# Promenljive
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_DIR="../../dagger-relic"
OUTPUT_FILE="$(pwd)/memcheck_output_$DATE.txt"
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

# Pokretanje valgrind memcheck
echo "Pokrecemo Valgrind Memcheck..."
cd "$PROJECT_DIR"
timeout -s INT "$TIMEOUT_DURATION"s valgrind \
    --leak-check=full \
    --show-leak-kinds=definite,indirect,possible \
    --track-origins=yes \
    --num-callers=10 \
    --log-file="$OUTPUT_FILE" \
    "$EXECUTABLE"

echo "Analiza zavrsena. Rezultati sacuvani u: $OUTPUT_FILE"
