```julia
Pkg.build(; verbose = false, io::IO=stderr)
Pkg.build(pkg::Union{String, Vector{String}}; verbose = false, io::IO=stderr)
Pkg.build(pkgs::Union{PackageSpec, Vector{PackageSpec}}; verbose = false, io::IO=stderr)
```

**Keyword arguments:**

  * `verbose::Bool=false`: print the build output to `stdout`/`stderr` instead of redirecting to the `build.log` file.
  * `allow_reresolve::Bool=true`: allow Pkg to reresolve the package versions in the build environment

!!! compat "Julia 1.13"
    `allow_reresolve` requires at least Julia 1.13.


Run the build script in `deps/build.jl` for `pkg` and all of its dependencies in depth-first recursive order. If no argument is given to `build`, the current project is built, which thus needs to be a package. This function is called automatically on any package that gets installed for the first time.

The build takes place in a new process matching the current process with default of `startup-file=no`. If using the startup file (`~/.julia/config/startup.jl`) is desired, start julia with an explicit `--startup-file=yes`.
