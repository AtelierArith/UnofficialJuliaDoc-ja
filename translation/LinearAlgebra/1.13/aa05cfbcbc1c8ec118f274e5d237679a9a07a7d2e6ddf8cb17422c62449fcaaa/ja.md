```julia
isposdef(A) -> Bool
```

`A` のコレスキー分解を試みて、行列が正定値（かつエルミート）かどうかを判定します。

関連項目: [`isposdef!`](@ref)、[`cholesky`](@ref)。

# Examples

```jldoctest
julia> A = [1 2; 2 50]
2×2 Matrix{Int64}:
 1   2
 2  50

julia> isposdef(A)
true
```
