```julia
nullspace(M; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
nullspace(M, rtol::Real) = nullspace(M; rtol=rtol) # to be deprecated in Julia 2.0
```

`M`のヌル空間の基底を計算します。これは、`M`の特異値のうち、絶対値が`max(atol, rtol*σ₁)`より小さい特異ベクトルを含むもので、ここで`σ₁`は`M`の最大特異値です。

デフォルトでは、相対許容誤差`rtol`は`n*ϵ`であり、`n`は`M`の最小次元のサイズ、`ϵ`は`M`の要素型の[`eps`](@ref)です。

# 例

```jldoctest
julia> M = [1 0 0; 0 1 0; 0 0 0]
3×3 Matrix{Int64}:
 1  0  0
 0  1  0
 0  0  0

julia> nullspace(M)
3×1 Matrix{Float64}:
 0.0
 0.0
 1.0

julia> nullspace(M, rtol=3)
3×3 Matrix{Float64}:
 0.0  1.0  0.0
 1.0  0.0  0.0
 0.0  0.0  1.0

julia> nullspace(M, atol=0.95)
3×1 Matrix{Float64}:
 0.0
 0.0
 1.0
```
