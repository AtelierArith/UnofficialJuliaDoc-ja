```julia
splice!(a::Vector, index::Integer, [replacement]) -> item
```

指定したインデックスの要素を削除し、削除した要素を返します。後続の要素は左に詰められ、空いた位置を埋めます。指定した場合は、順序付きコレクションの置換値が、削除した要素の位置に挿入されます。

関連項目: [`replace`](@ref)、[`delete!`](@ref)、[`deleteat!`](@ref)、[`pop!`](@ref)、[`popat!`](@ref)。

# Examples

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

要素を削除せずにインデックス `n` の前に `replacement` を挿入するには、`splice!(collection, n:n-1, replacement)` を使用します。
