```julia
Adjoint
```

基になる線形代数オブジェクト、通常は `AbstractVector`/`AbstractMatrix` の随伴ビューのための遅延ラッパー型です。通常、`Adjoint` コンストラクタは直接呼び出すべきではなく、代わりに [`adjoint`](@ref) を使用してください。ビューを具現化するには [`copy`](@ref) を使用します。

この型は線形代数の使用を目的としています - 一般的なデータ操作については [`permutedims`](@ref Base.permutedims) を参照してください。

# 例

```jldoctest
julia> A = [3+2im 9+2im; 0 0]
2×2 Matrix{Complex{Int64}}:
 3+2im  9+2im
 0+0im  0+0im

julia> Adjoint(A)
2×2 adjoint(::Matrix{Complex{Int64}}) with eltype Complex{Int64}:
 3-2im  0+0im
 9-2im  0+0im
```
