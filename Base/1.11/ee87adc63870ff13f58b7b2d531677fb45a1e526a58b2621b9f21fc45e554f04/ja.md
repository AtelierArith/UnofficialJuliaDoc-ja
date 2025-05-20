```
replace!(A, old_new::Pair...; [count::Integer])
```

各ペア `old=>new` に対して、コレクション `A` 内の `old` のすべての出現を `new` に置き換えます。等価性は [`isequal`](@ref) を使用して決定されます。`count` が指定されている場合、合計で最大 `count` 回の出現を置き換えます。詳細は [`replace`](@ref replace(A, old_new::Pair...)) を参照してください。

# 例

```jldoctest
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
