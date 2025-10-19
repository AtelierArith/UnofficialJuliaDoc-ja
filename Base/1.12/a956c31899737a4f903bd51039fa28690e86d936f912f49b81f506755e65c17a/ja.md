```julia
setdiff!(s, itrs...)
```

セット`s`から、`itrs`の各イテラブルの各要素を（インプレースで）削除します。配列を使用して順序を維持します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

```jldoctest
julia> a = Set([1, 3, 4, 5]);

julia> setdiff!(a, 1:2:6);

julia> a
Set{Int64} with 1 element:
  4
```
