```julia
Tuple{Types...}
```

A tuple is a fixed-length container that can hold any values of different types, but cannot be modified (it is immutable). The values can be accessed via indexing. Tuple literals are written with commas and parentheses:

```jldoctest
julia> (1, 1+1)
(1, 2)

julia> (1,)
(1,)

julia> x = (0.0, "hello", 6*7)
(0.0, "hello", 42)

julia> x[2]
"hello"

julia> typeof(x)
Tuple{Float64, String, Int64}
```

A length-1 tuple must be written with a comma, `(1,)`, since `(1)` would just be a parenthesized value. `()` represents the empty (length-0) tuple.

A tuple can be constructed from an iterator by using a `Tuple` type as constructor:

```jldoctest
julia> Tuple(["a", 1])
("a", 1)

julia> Tuple{String, Float64}(["a", 1])
("a", 1.0)
```

Tuple types are covariant in their parameters: `Tuple{Int}` is a subtype of `Tuple{Any}`. Therefore `Tuple{Any}` is considered an abstract type, and tuple types are only concrete if their parameters are. Tuples do not have field names; fields are only accessed by index. Tuple types may have any number of parameters.

See the manual section on [Tuple Types](@ref).

See also [`Vararg`](@ref), [`NTuple`](@ref), [`ntuple`](@ref), [`tuple`](@ref), [`NamedTuple`](@ref).
