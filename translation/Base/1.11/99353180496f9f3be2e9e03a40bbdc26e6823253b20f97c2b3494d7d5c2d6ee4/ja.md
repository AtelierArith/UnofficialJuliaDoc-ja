```
tail(x::Tuple)::Tuple
```

`x`の最初のコンポーネントを除くすべてのコンポーネントからなる`Tuple`を返します。

参照: [`front`](@ref Base.front), [`rest`](@ref Base.rest), [`first`](@ref), [`Iterators.peel`](@ref).

# 例

```jldoctest
julia> Base.tail((1,2,3))
(2, 3)

julia> Base.tail(())
ERROR: ArgumentError: Cannot call tail on an empty tuple.
```
