```
Memory{T}(undef, n)
```

Construct an uninitialized [`Memory{T}`](@ref) of length `n`. All Memory objects of length 0 might alias, since there is no reachable mutable content from them.

# Examples

```julia-repl
julia> Memory{Float64}(undef, 3)
3-element Memory{Float64}:
 6.90966e-310
 6.90966e-310
 6.90966e-310
```
