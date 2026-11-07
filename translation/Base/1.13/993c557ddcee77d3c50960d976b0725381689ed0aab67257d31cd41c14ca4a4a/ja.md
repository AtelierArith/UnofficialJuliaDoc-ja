```julia
front(x::Tuple)::Tuple
```

`Tuple`は、`x`の最後の要素を除いたものを返します。

関連項目: [`first`](@ref)、[`tail`](@ref Base.tail)。

# Examples

```jldoctest
julia> Base.front((1,2,3))
(1, 2)

julia> Base.front(())
ERROR: ArgumentError: Cannot call front on an empty tuple.
```
