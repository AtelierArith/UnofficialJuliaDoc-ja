```julia
take(iter, n)
```

イテレータで、`iter`の最初の`n`要素を最大で生成します。

関連項目: [`drop`](@ref Iterators.drop), [`peel`](@ref Iterators.peel), [`first`](@ref), [`Base.take!`](@ref).

# 例

```jldoctest
julia> a = 1:2:11
1:2:11

julia> collect(a)
6-element Vector{Int64}:
  1
  3
  5
  7
  9
 11

julia> collect(Iterators.take(a,3))
3-element Vector{Int64}:
 1
 3
 5
```
