```julia
Pkg.build(; verbose = false, io::IO=stderr)
Pkg.build(pkg::Union{String, Vector{String}}; verbose = false, io::IO=stderr)
Pkg.build(pkgs::Union{PackageSpec, Vector{PackageSpec}}; verbose = false, io::IO=stderr)
```

Run the build script in `deps/build.jl` for `pkg` and all of its dependencies in depth-first recursive order. If no argument is given to `build`, the current project is built, which thus needs to be a package. This function is called automatically on any package that gets installed for the first time. `verbose = true` prints the build output to `stdout`/`stderr` instead of redirecting to the `build.log` file.
