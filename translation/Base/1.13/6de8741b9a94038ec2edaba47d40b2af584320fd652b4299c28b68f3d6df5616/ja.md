```julia
replace!(A, old_new::Pair...; [count::Integer])
```

`old_new` 内の各ペア `old=>new` について、コレクション `A` 内にあるすべての `old` を `new` に置き換えます。等値性は [`isequal`](@ref) を使用して判定します。`count` を指定した場合、置換する出現箇所は合計で最大 `count` 個となります。[`replace`](@ref replace(A, old_new::Pair...)) も参照してください。

# Examples

```jldoctest; filter = r"^\s+\d$"m
julia> replace!([1, 2, 1, 3], 1=>0, 2=>4, count=2)
4-element Vector{Int64}:
 0
 4
 1
 3

julia> replace!(Set([1, 2, 3]), 1=>0)
Set{Int64} with 3 elements:
  0
  2
  3
```
