#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<'EOF'
Usage: ./export-rules-pdf.sh [HTML_FILE ...]

Convert one or more HTML rules documents to standalone LaTeX, then compile
them to PDF with Tectonic and export them as EPUB 3 ebooks. Relative paths
are checked from both the current directory and the directory containing
this script.

With no arguments, exports:
  Core-Rules.html

The generated .tex, .pdf, and .epub files are written beside each source
HTML file. Running the script again overwrites those generated files.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

for required_command in pandoc tectonic; do
    if ! command -v "$required_command" >/dev/null 2>&1; then
        printf 'Error: required command not found: %s\n' "$required_command" >&2
        exit 1
    fi
done

if [[ "$#" -eq 0 ]]; then
    inputs=(
        "$script_dir/Core-Rules.html"
    )
else
    inputs=("$@")
fi

for requested_input in "${inputs[@]}"; do
    if [[ -f "$requested_input" ]]; then
        input="$requested_input"
    elif [[ -f "$script_dir/$requested_input" ]]; then
        input="$script_dir/$requested_input"
    else
        printf 'Error: HTML file not found: %s\n' "$requested_input" >&2
        exit 1
    fi

    input_dir="$(cd -- "$(dirname -- "$input")" && pwd)"
    input_name="$(basename -- "$input")"
    stem="${input_name%.*}"
    tex_path="$input_dir/$stem.tex"
    pdf_path="$input_dir/$stem.pdf"
    epub_path="$input_dir/$stem.epub"

    printf 'Converting %s to %s\n' "$input_name" "$(basename -- "$tex_path")"
    pandoc "$input" \
        --from=html \
        --to=latex \
        --standalone \
        --toc \
        --toc-depth=5 \
        --number-sections \
        --top-level-division=chapter \
        --variable=documentclass:book \
        --variable=geometry:margin=1in \
        --metadata=lang:en \
        --resource-path="$input_dir:$script_dir" \
        --lua-filter="$script_dir/latex-table-widths.lua" \
        --output="$tex_path"

    printf 'Compiling %s with Tectonic\n' "$(basename -- "$tex_path")"
    tectonic --outdir "$input_dir" "$tex_path"

    if [[ ! -s "$pdf_path" ]]; then
        printf 'Error: Tectonic did not create %s\n' "$pdf_path" >&2
        exit 1
    fi

    printf 'Created %s\n' "$pdf_path"

    printf 'Converting %s to %s\n' "$input_name" "$(basename -- "$epub_path")"
    pandoc "$input" \
        --from=html+raw_html \
        --to=epub3+raw_html \
        --standalone \
        --toc \
        --toc-depth=5 \
        --number-sections \
        --split-level=1 \
        --metadata=lang:en \
        --resource-path="$input_dir:$script_dir" \
        --css="$script_dir/epub.css" \
        --output="$epub_path"

    if [[ ! -s "$epub_path" ]]; then
        printf 'Error: Pandoc did not create %s\n' "$epub_path" >&2
        exit 1
    fi

    printf 'Created %s\n' "$epub_path"
done
