```julia
IdSet{T}([itr])
IdSet()
```

IdSet{T}() constructs a set (see [`Set`](@ref)) using `===` as equality with values of type `T`.

In the example below, the values are all `isequal` so they get overwritten in the ordinary `Set`. The `IdSet` compares by `===` and so preserves the 3 different values.

!!! compat "Julia 1.11"
    Exported in Julia 1.11 and later.


# Examples

```jldoctest; filter = r"\n\s*(1|1\.0|true)"
julia> Set(Any[true, 1, 1.0])
Set{Any} with 1 element:
  1.0

julia> IdSet{Any}(Any[true, 1, 1.0])
IdSet{Any} with 3 elements:
  1.0
  1
  true
```
