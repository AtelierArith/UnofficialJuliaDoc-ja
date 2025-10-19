```julia
product(iters...)
```

複数のイテレータの積に対するイテレータを返します。生成される各要素はタプルで、その `i` 番目の要素は `i` 番目の引数イテレータから来ます。最初のイテレータが最も速く変化します。

関連: [`zip`](@ref), [`Iterators.flatten`](@ref).

# 例

```jldoctest
julia> collect(Iterators.product(1:2, 3:5))
2×3 Matrix{Tuple{Int64, Int64}}:
 (1, 3)  (1, 4)  (1, 5)
 (2, 3)  (2, 4)  (2, 5)

julia> ans == [(x,y) for x in 1:2, y in 3:5]  # Iterators.productを含むジェネレータを収集
true
```
