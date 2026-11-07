```julia
product(iters...)
```

複数のイテレータの直積を走査するイテレータを返します。生成される各要素はタプルであり、その`i`番目の要素は、引数として渡された`i`番目のイテレータから取得されます。最初のイテレータが最も速く変化します。

関連項目: [`zip`](@ref)、[`Iterators.flatten`](@ref)。

# Examples

```jldoctest
julia> collect(Iterators.product(1:2, 3:5))
2×3 Matrix{Tuple{Int64, Int64}}:
 (1, 3)  (1, 4)  (1, 5)
 (2, 3)  (2, 4)  (2, 5)

julia> ans == [(x,y) for x in 1:2, y in 3:5]  # collects a generator involving Iterators.product
true
```
