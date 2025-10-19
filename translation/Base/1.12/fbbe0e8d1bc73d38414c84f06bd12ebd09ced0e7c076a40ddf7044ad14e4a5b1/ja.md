```julia
splice!(a::Vector, index::Integer, [replacement]) -> item
```

指定されたインデックスのアイテムを削除し、削除されたアイテムを返します。以降のアイテムは、結果として生じた隙間を埋めるために左にシフトされます。指定された場合、順序付きコレクションからの置換値が削除されたアイテムの代わりに挿入されます。

参照: [`replace`](@ref), [`delete!`](@ref), [`deleteat!`](@ref), [`pop!`](@ref), [`popat!`](@ref)。

# 例

```jldoctest
julia> A = [6, 5, 4, 3, 2, 1]; splice!(A, 5)
2

julia> A
5-element Vector{Int64}:
 6
 5
 4
 3
 1

julia> splice!(A, 5, -1)
1

julia> A
5-element Vector{Int64}:
  6
  5
  4
  3
 -1

julia> splice!(A, 1, [-1, -2, -3])
6

julia> A
7-element Vector{Int64}:
 -1
 -2
 -3
  5
  4
  3
 -1
```

アイテムを削除せずにインデックス `n` の前に `replacement` を挿入するには、`splice!(collection, n:n-1, replacement)` を使用します。
