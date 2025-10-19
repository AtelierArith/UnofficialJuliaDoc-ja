```julia
isposdef!(A) -> Bool
```

行列が正定値（およびエルミート）であるかどうかを、`A`のコレスキー因子分解を試みることでテストします。この過程で`A`が上書きされます。詳細は[`isposdef`](@ref)を参照してください。

# 例

```jldoctest
julia> A = [1. 2.; 2. 50.];

julia> isposdef!(A)
true

julia> A
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  6.78233
```
