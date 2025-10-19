```julia
Base.locate_package(pkg::PkgId)::Union{String, Nothing}
```

The path to the entry-point file for the package corresponding to the identifier `pkg`, or `nothing` if not found. See also [`identify_package`](@ref).

```julia-repl
julia> pkg = Base.identify_package("Pkg")
Pkg [44cfe95a-1eb2-52ea-b672-e2afdf69b78f]

julia> Base.locate_package(pkg)
"/path/to/julia/stdlib/v1.12/Pkg/src/Pkg.jl"
```
