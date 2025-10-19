#!/bin/bash
set -eux

cp assets/Project_1.12.1.toml julia/doc/Project.toml
cp assets/Manifest_1.12.1.toml julia/doc/Manifest.toml
cp assets/make_1.12.1.jl julia/doc/make.jl

make -C julia
make -C julia/doc
# clean up
git -C julia checkout .
