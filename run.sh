#!/bin/bash
set -eux

cp assets/Project_1.11.5.toml julia/doc/Project.toml
cp assets/Manifest_1.11.5.toml julia/doc/Manifest.toml
cp assets/make_1.11.5.jl julia/doc/make.jl

make -C julia
make -C julia/doc
# clean up
git -C julia checkout .
