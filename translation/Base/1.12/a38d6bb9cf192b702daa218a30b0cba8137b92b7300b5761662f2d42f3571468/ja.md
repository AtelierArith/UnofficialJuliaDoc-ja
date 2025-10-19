```julia
vect(X...)
```

引数の `promote_typeof` から計算された要素型を持つ [`Vector`](@ref) を作成し、引数リストを含みます。

# 例

```jldoctest
julia> a = Base.vect(UInt8(1), 2.5, 1//2)
3-element Vector{Float64}:
 1.0
 2.5
 0.5
```
