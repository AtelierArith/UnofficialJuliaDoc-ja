```julia
Base.showarg(io::IO, x, toplevel)
```

Show the quasi-type of `x` where quasi-type is the type of `x` or an expression (possibly containing quasi-types) that would generate an object of the same type as `x`. The shorter of these two options is typically used.

This function is used by `summary` to display type information in terms of sequences of function calls on objects.

Show a leading `::` if `toplevel` is `false` and showing a type. `toplevel` is `true` if this is the direct call from `summary` and `false` for nested (recursive) calls.

The fallback definition is to print `x` as "::$(typeof(x))" or "$(typeof(x))", representing argument `x` in terms of its type. However, you can specialize this function for specific types to customize printing. This customization is useful for types that have simple, public constructors and verbose and/or internal types and type parameters such as `reinterpret`ed arrays or `SubArray`s.

# Examples

A SubArray created as `view(a, :, 3, 2:5)`, where `a` is a 3-dimensional Float64 array, has type

```julia
SubArray{Float64, 2, Array{Float64, 3}, Tuple{Colon, Int64, UnitRange{Int64}}, false}
```

The default `show` printing would display this full type. However, the summary for SubArrays actually prints as

```julia
2×4 view(::Array{Float64, 3}, :, 3, 2:5) with eltype Float64
```

because of a definition similar to

```julia
function Base.showarg(io::IO, v::SubArray, toplevel)
    print(io, "view(")
    showarg(io, parent(v), false)
    print(io, ", ", join(v.indices, ", "))
    print(io, ')')
    toplevel && print(io, " with eltype ", eltype(v))
end
```

Note that we're calling `showarg` recursively for the parent array type, indicating that any recursed calls are not at the top level. Printing the parent as `::Array{Float64,3}` is the fallback (non-toplevel) behavior, because no specialized method for `Array` has been defined.
