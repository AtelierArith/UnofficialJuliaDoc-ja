```
union!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

渡された集合の[`union`](@ref)を構築し、結果で`s`を上書きします。配列の順序を維持します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

```jldoctest
julia> a = Set([3, 4, 5]);

julia> union!(a, 1:2:7);

julia> a
Set{Int64} with 5 elements:
  5
  4
  7
  3
  1
```
