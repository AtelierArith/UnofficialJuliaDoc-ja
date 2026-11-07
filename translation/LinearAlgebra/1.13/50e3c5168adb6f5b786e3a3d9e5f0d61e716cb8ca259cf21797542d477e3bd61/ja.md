```julia
UniformScaling{T<:Number}
```

スカラーと単位作用素の積として定義される、サイズが汎用的な一様スケーリング作用素 `λ*I`。明示的な `size` はありませんが、多くの場合、行列と同様に動作し、一部のインデックス指定にも対応しています。[`I`](@ref) も参照してください。

!!! compat "Julia 1.6"
    範囲を使ったインデックス指定は Julia 1.6 以降で利用できます。


# Examples

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
