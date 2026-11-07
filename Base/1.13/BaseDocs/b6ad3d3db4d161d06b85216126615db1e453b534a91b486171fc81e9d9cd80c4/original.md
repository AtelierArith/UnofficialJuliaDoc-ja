```julia
getfield(value, name::Symbol, [order::Symbol], [boundscheck::Bool=true])
getfield(value, i::Int, [order::Symbol], [boundscheck::Bool=true])
```

Extract a field from a composite `value` by name or position.

Optionally, an ordering can be defined for the operation. If the field was declared `@atomic`, the specification is strongly recommended to be compatible with the stores to that location. Otherwise, if not declared as `@atomic`, this parameter must be `:not_atomic` if specified.

The bounds check may be disabled, in which case the behavior of this function is undefined if `i` is out of bounds.

See also [`getproperty`](@ref Base.getproperty) and [`fieldnames`](@ref).

# Examples

```jldoctest
julia> a = 1//2
1//2

julia> getfield(a, :num)
1

julia> a.num
1

julia> getfield(a, 1)
1
```
