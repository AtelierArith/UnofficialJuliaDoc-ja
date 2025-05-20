```
undef
```

Alias for `UndefInitializer()`, which constructs an instance of the singleton type [`UndefInitializer`](@ref), used in array initialization to indicate the array-constructor-caller would like an uninitialized array.

See also: [`missing`](@ref), [`similar`](@ref).

# Examples

```julia-repl
julia> Array{Float64, 1}(undef, 3)
3-element Vector{Float64}:
 2.2752528595e-314
 2.202942107e-314
 2.275252907e-314
```
