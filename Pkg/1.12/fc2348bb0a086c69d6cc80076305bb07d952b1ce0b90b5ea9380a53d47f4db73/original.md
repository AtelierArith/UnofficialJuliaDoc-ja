```julia
Pkg.add(pkg::Union{String, Vector{String}}; preserve=PRESERVE_TIERED, target::Symbol=:deps)
Pkg.add(pkg::Union{PackageSpec, Vector{PackageSpec}}; preserve=PRESERVE_TIERED, target::Symbol=:deps)
```

Add a package to the current project. This package will be available by using the `import` and `using` keywords in the Julia REPL, and if the current project is a package, also inside that package.

If the active environment is a package (the Project has both `name` and `uuid` fields) compat entries will be added automatically with a lower bound of the added version.

To add as a weak dependency (in the `[weakdeps]` field) set the kwarg `target=:weakdeps`. To add as an extra dep (in the `[extras]` field) set `target=:extras`.

## Resolution Tiers

`Pkg` resolves the set of packages in your environment using a tiered algorithm. The `preserve` keyword argument allows you to key into a specific tier in the resolve algorithm. The following table describes the argument values for `preserve` (in order of strictness):

| Value                       | Description                                                                        |
|:--------------------------- |:---------------------------------------------------------------------------------- |
| `PRESERVE_ALL_INSTALLED`    | Like `PRESERVE_ALL` and only add those already installed                           |
| `PRESERVE_ALL`              | Preserve the state of all existing dependencies (including recursive dependencies) |
| `PRESERVE_DIRECT`           | Preserve the state of all existing direct dependencies                             |
| `PRESERVE_SEMVER`           | Preserve semver-compatible versions of direct dependencies                         |
| `PRESERVE_NONE`             | Do not attempt to preserve any version information                                 |
| `PRESERVE_TIERED_INSTALLED` | Like `PRESERVE_TIERED` except `PRESERVE_ALL_INSTALLED` is tried first              |
| `PRESERVE_TIERED`           | Use the tier that will preserve the most version information while                 |
|                             | allowing version resolution to succeed (this is the default)                       |

!!! note
    To change the default strategy to `PRESERVE_TIERED_INSTALLED` set the env var `JULIA_PKG_PRESERVE_TIERED_INSTALLED` to true.


After the installation of new packages the project will be precompiled. For more information see `pkg> ?precompile`.

With the `PRESERVE_ALL_INSTALLED` strategy the newly added packages will likely already be precompiled, but if not this may be because either the combination of package versions resolved in this environment has not been resolved and precompiled before, or the precompile cache has been deleted by the LRU cache storage (see `JULIA_MAX_NUM_PRECOMPILE_FILES`).

!!! compat "Julia 1.9"
    The `PRESERVE_TIERED_INSTALLED` and `PRESERVE_ALL_INSTALLED` strategies requires at least Julia 1.9.


!!! compat "Julia 1.11"
    The `target` kwarg requires at least Julia 1.11.


# Examples

```julia
Pkg.add("Example") # Add a package from registry
Pkg.add("Example", target=:weakdeps) # Add a package as a weak dependency
Pkg.add("Example", target=:extras) # Add a package to the `[extras]` list
Pkg.add("Example"; preserve=Pkg.PRESERVE_ALL) # Add the `Example` package and strictly preserve existing dependencies
Pkg.add(name="Example", version="0.3") # Specify version; latest release in the 0.3 series
Pkg.add(name="Example", version="0.3.1") # Specify version; exact release
Pkg.add(url="https://github.com/JuliaLang/Example.jl", rev="master") # From url to remote gitrepo
Pkg.add(url="/remote/mycompany/juliapackages/OurPackage") # From path to local gitrepo
Pkg.add(url="https://github.com/Company/MonoRepo", subdir="juliapkgs/Package.jl)") # With subdir
```

After the installation of new packages the project will be precompiled. See more at [Environment Precompilation](@ref).

See also [`PackageSpec`](@ref), [`Pkg.develop`](@ref).
