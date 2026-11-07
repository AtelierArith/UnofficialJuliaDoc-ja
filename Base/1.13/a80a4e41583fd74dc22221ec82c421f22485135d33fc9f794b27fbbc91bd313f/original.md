```julia
takestring!(x)::AbstractString
```

Create a string from the content of `x`, emptying `x`.

# Examples

```jldoctest
julia> v = [0x61, 0x62, 0x63];

julia> s = takestring!(v)
"abc"

julia> isempty(v)
true
```

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.

