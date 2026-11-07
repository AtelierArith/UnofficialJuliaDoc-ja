```julia
Adjoint
```

元の線形代数オブジェクト（通常は `AbstractVector`/`AbstractMatrix`）の随伴ビューを表す遅延ラッパー型です。通常、`Adjoint` コンストラクターを直接呼び出す必要はありません。代わりに [`adjoint`](@ref) を使用してください。ビューを実体化するには [`copy`](@ref) を使用します。

この型は線形代数での使用を想定しています。一般的なデータ操作については [`permutedims`](@ref Base.permutedims) を参照してください。

# Examples

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
