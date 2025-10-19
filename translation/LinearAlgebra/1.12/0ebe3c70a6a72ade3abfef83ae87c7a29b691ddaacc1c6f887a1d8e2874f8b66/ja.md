```julia
lyap(A, C)
```

連続リャプノフ方程式 `AX + XA' + C = 0` の解 `X` を計算します。ここで、`A` の固有値の実部はゼロではなく、2つの固有値が負の複素共役であることはありません。

# 例

```jldoctest
julia> A = [3. 4.; 5. 6]
2×2 Matrix{Float64}:
 3.0  4.0
 5.0  6.0

julia> B = [1. 1.; 1. 2.]
2×2 Matrix{Float64}:
 1.0  1.0
 1.0  2.0

julia> X = lyap(A, B)
2×2 Matrix{Float64}:
  0.5  -0.5
 -0.5   0.25

julia> A*X + X*A' ≈ -B
true
```
