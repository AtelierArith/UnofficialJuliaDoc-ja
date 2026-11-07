#!/bin/bash
set -eu

cd "$(dirname "$0")"

if [ "$(cat julia/VERSION)" != "1.13.3" ]; then
    echo "Expected Julia 1.13.3; initialize the pinned julia submodule first." >&2
    exit 1
fi

# Use a separate environment so the upstream and 1.12 manifests are untouched.
mkdir -p julia/doc/translation-env
cp assets/Project_1.13.3.toml julia/doc/translation-env/Project.toml
cp assets/Manifest_1.13.3.toml julia/doc/translation-env/Manifest.toml

# Restore only the file replaced by this script, including on build failure.
original_make=$(mktemp)
cp julia/doc/make.jl "$original_make"
cleanup() {
    cp "$original_make" julia/doc/make.jl
    rm -f "$original_make"
}
trap cleanup EXIT
cp assets/make_1.13.3.jl julia/doc/make.jl

make -C julia
make -C julia/doc
