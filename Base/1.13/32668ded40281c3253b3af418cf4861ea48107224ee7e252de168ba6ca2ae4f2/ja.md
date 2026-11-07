```julia
splice!(a::Vector, indices, [replacement]) -> items
```

指定したインデックスの要素を削除し、削除した要素を含むコレクションを返します。後続の要素は左に詰められ、空いた位置を埋めます。指定した場合は、順序付きコレクションの置換値が削除した要素の位置に挿入されます。この場合、`indices` は `AbstractUnitRange` でなければなりません。

要素を削除せずに、インデックス `n` の前に `replacement` を挿入するには、`splice!(collection, n:n-1, replacement)` を使用します。

!!! warning
    変更対象の引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


!!! compat "Julia 1.5"
    Julia 1.5 より前のバージョンでは、`indices` は常に `UnitRange` でなければなりません。


!!! compat "Julia 1.8"
    Julia 1.8 より前のバージョンでは、置換値を挿入する場合、`indices` は `UnitRange` でなければなりません。


# Examples

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
