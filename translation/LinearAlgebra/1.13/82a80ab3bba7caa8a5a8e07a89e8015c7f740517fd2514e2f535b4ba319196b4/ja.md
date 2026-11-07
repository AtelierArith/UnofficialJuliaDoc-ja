```julia
isposdef!(A) -> Bool
```

`A` のコレスキー分解を試みることで、行列が正定値（かつエルミート）かどうかを判定します。その際、`A` は上書きされます。[`isposdef`](@ref) も参照してください。

# Examples

```jldoctest
julia> A = [1. 2.; 2. 50.];

julia> isposdef!(A)
true

julia> A
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  6.78233
```
