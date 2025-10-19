```julia
cbrt(A::AbstractMatrix{<:Real})
```

実数値行列 `A` の実数値立方根を計算します。もし `T = cbrt(A)` であれば、`T*T*T ≈ A` となります。以下に示す例を参照してください。

`A` が対称である場合、すなわち `HermOrSym{<:Real}` 型である場合は、([`eigen`](@ref)) を使用して立方根を求めます。それ以外の場合は、p-th ルートアルゴリズムの特化版 [^S03] が利用され、実数値シュール分解 ([`schur`](@ref)) を利用して立方根を計算します。

[^S03]: Matthew I. Smith, "A Schur Algorithm for Computing Matrix pth Roots", SIAM Journal on Matrix Analysis and Applications, vol. 24, 2003, pp. 971–989. [doi:10.1137/S0895479801392697](https://doi.org/10.1137/s0895479801392697)

# 例

```jldoctest
julia> A = [0.927524 -0.15857; -1.3677 -1.01172]
2×2 Matrix{Float64}:
  0.927524  -0.15857
 -1.3677    -1.01172

julia> T = cbrt(A)
2×2 Matrix{Float64}:
  0.910077  -0.151019
 -1.30257   -0.936818

julia> T*T*T ≈ A
true
```
