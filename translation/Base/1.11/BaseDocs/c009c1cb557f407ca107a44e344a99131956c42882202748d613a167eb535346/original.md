```
Integer <: Real
```

Abstract supertype for all integers (e.g. [`Signed`](@ref), [`Unsigned`](@ref), and [`Bool`](@ref)).

See also [`isinteger`](@ref), [`trunc`](@ref), [`div`](@ref).

# Examples

```
julia> 42 isa Integer
true

julia> 1.0 isa Integer
false

julia> isinteger(1.0)
true
```
