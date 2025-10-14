#!/usr/bin/env bash
set -e

# Promenljive
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_DIR="../dagger-relic"
BUILD_DIR="$PROJECT_DIR/builddir"
OUTPUT_FILE="clang_tidy_output_$DATE.txt"

# Dodatne opcije za clang-tidy
CHECKS="clang-analyzer-*,cppcoreguidelines-*,modernize-*,performance-*,readability-*"

# Ako builddir ne postoji ili compile_commands.json fali, builduj projekat
if [ ! -f "$BUILD_DIR/compile_commands.json" ]; then
    echo "Nema detektovanog $BUILD_DIR/compile_commands.json, buildujemo projekat..."
    meson setup "$BUILD_DIR" "$PROJECT_DIR" >/dev/null
    meson compile -C "$BUILD_DIR" >/dev/null
else
    echo "Pronadjen $BUILD_DIR/compile_commands.json, preskacemo buildovanje."
fi

# Pokretanje clang-tidy
echo "Pokrecemo clang-tidy..."
clang-tidy "$PROJECT_DIR"/src/*.cpp -checks="$CHECKS" -p "$BUILD_DIR" > "$OUTPUT_FILE" 2>&1

echo "Analiza zavrsena. Rezultati sacuvani u: $OUTPUT_FILE."
