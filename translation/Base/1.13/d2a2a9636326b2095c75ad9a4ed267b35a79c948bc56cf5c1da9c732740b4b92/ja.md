```julia
setdiff!(s, itrs...)
```

`s` から、`itrs` の各反復可能オブジェクトに含まれる要素を削除します（インプレース）。配列では順序を維持します。

!!! warning
    変更される引数が、ほかのいずれかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

```jldoctest
julia> a = Set([1, 3, 4, 5]);

julia> setdiff!(a, 1:2:6);

julia> a
Set{Int64} with 1 element:
  4
```
