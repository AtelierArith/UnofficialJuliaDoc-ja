```julia
front(x::Tuple)::Tuple
```

`x`の最後の要素を除いたすべての要素からなる`Tuple`を返します。

参照: [`first`](@ref), [`tail`](@ref Base.tail).

# 例

```jldoctest
julia> Base.front((1,2,3))
(1, 2)

julia> Base.front(())
ERROR: ArgumentError: Cannot call front on an empty tuple.
```
