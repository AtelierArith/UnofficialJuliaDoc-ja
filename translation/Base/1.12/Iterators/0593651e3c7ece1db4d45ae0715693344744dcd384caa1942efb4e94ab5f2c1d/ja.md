```julia
rest(iter, state)
```

与えられた `state` から始まる `iter` と同じ要素を生成するイテレータです。

関連: [`Iterators.drop`](@ref), [`Iterators.peel`](@ref), [`Base.rest`](@ref).

# 例

```jldoctest
julia> collect(Iterators.rest([1,2,3,4], 2))
3-element Vector{Int64}:
 2
 3
 4
```
