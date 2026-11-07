```julia
Transpose
```

元の線形代数オブジェクト（通常は `AbstractVector`/`AbstractMatrix`）の転置ビューを表す遅延ラッパー型です。通常、`Transpose` コンストラクターを直接呼び出すべきではありません。代わりに [`transpose`](@ref) を使用してください。ビューを実体化するには [`copy`](@ref) を使用します。

この型は線形代数での使用を想定しています。一般的なデータ操作については [`permutedims`](@ref Base.permutedims) を参照してください。

# Examples

```jldoctest
julia> A = [2 3; 0 0]
2×2 Matrix{Int64}:
 2  3
 0  0

julia> Transpose(A)
2×2 transpose(::Matrix{Int64}) with eltype Int64:
 2  0
 3  0
```
