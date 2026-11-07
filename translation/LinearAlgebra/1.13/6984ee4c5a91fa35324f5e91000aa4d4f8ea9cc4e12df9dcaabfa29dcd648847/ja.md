```julia
det(M)
```

行列式。

関連項目: [`logdet`](@ref) および [`logabsdet`](@ref)。

# Examples

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> det(M)
2.0
```

一般に、`det` は整数行列に対しても、通常はガウス消去法を用いて、行列式の浮動小数点近似値を計算することに注意してください。Julia には整数行列式を厳密に計算するアルゴリズム（Bareiss アルゴリズム）が含まれていますが、既定では `BigInt` 行列に対してのみ使用されます（行列式は固定精度の整数で扱える範囲をすぐに超えてしまうため）。

```jldoctest
julia> det(BigInt[1 0; 2 2]) # exact integer determinant
2
```
