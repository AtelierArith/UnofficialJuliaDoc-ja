```julia
tail(x::Tuple)::Tuple
```

`x` の最初の要素を除いたすべての要素からなる `Tuple` を返します。

関連項目: [`front`](@ref Base.front)、[`rest`](@ref Base.rest)、[`first`](@ref)、[`Iterators.peel`](@ref)。

# Examples

```jldoctest
julia> Base.tail((1,2,3))
(2, 3)

julia> Base.tail(())
ERROR: ArgumentError: Cannot call tail on an empty tuple.
```
