```julia
@isdefined s -> Bool
```

Tests whether variable `s` is defined in the current scope.

See also [`isdefined`](@ref) for field properties and [`isassigned`](@ref) for array indexes or [`haskey`](@ref) for other mappings.

# Examples

```jldoctest
julia> @isdefined newvar
false

julia> newvar = 1
1

julia> @isdefined newvar
true

julia> function f()
           println(@isdefined x)
           x = 3
           println(@isdefined x)
       end
f (generic function with 1 method)

julia> f()
false
true
```
