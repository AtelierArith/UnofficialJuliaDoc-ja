```julia
@trace_compile
```

A macro to execute an expression and show any methods that were compiled (or recompiled in yellow), like the julia args `--trace-compile=stderr --trace-compile-timing` but specifically for a call.

```julia-repl
julia> @trace_compile rand(2,2) * rand(2,2)
#=   39.1 ms =# precompile(Tuple{typeof(Base.rand), Int64, Int64})
#=  102.0 ms =# precompile(Tuple{typeof(Base.:(*)), Array{Float64, 2}, Array{Float64, 2}})
2×2 Matrix{Float64}:
 0.421704  0.864841
 0.211262  0.444366
```

!!! compat "Julia 1.12"
    This macro requires at least Julia 1.12

