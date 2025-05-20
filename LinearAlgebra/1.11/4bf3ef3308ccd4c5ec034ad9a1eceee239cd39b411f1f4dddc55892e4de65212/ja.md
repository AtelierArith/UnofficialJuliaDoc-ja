```
UniformScaling{T<:Number}
```

スカラーと単位演算子 `λ*I` の積として定義された一般的なサイズの均一スケーリング演算子。明示的な `size` はありませんが、多くの場合、行列のように動作し、一部のインデックス指定をサポートします。詳細は [`I`](@ref) を参照してください。

!!! compat "Julia 1.6"
    範囲を使用したインデックス指定は、Julia 1.6 以降で利用可能です。


# 例

```jldoctest
julia> J = UniformScaling(2.)
UniformScaling{Float64}
2.0*I

julia> A = [1. 2.; 3. 4.]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> J*A
2×2 Matrix{Float64}:
 2.0  4.0
 6.0  8.0

julia> J[1:2, 1:2]
2×2 Matrix{Float64}:
 2.0  0.0
 0.0  2.0
```
