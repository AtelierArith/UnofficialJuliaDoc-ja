```julia
splice!(a::Vector, indices, [replacement]) -> items
```

指定されたインデックスでアイテムを削除し、削除されたアイテムを含むコレクションを返します。以降のアイテムは、結果として生じる隙間を埋めるために左にシフトされます。指定された場合、順序付きコレクションからの置換値が削除されたアイテムの代わりに挿入されます。この場合、`indices`は`AbstractUnitRange`でなければなりません。

アイテムを削除せずにインデックス`n`の前に`replacement`を挿入するには、`splice!(collection, n:n-1, replacement)`を使用します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


!!! compat "Julia 1.5"
    Julia 1.5以前では、`indices`は常に`UnitRange`でなければなりません。


!!! compat "Julia 1.8"
    Julia 1.8以前では、置換値をスプライスする場合、`indices`は`UnitRange`でなければなりません。


# 例

```jldoctest
julia> A = [-1, -2, -3, 5, 4, 3, -1]; splice!(A, 4:3, 2)
Int64[]

julia> A
8-element Vector{Int64}:
 -1
 -2
 -3
  2
  5
  4
  3
 -1
```
