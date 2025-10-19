```julia
isposdef(A) -> Bool
```

行列が正定値（およびエルミート）であるかどうかを、`A`のコレスキー分解を試みることでテストします。

関連情報として、[`isposdef!`](@ref)、[`cholesky`](@ref)も参照してください。

# 例

```jldoctest
julia> A = [1 2; 2 50]
2×2 Matrix{Int64}:
 1   2
 2  50

julia> isposdef(A)
true
```
