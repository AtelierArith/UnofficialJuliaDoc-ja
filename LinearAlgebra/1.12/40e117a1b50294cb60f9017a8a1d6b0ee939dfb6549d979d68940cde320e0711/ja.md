```julia
copy(A::Transpose)
copy(A::Adjoint)
```

遅延行列の転置/随伴を即座に評価します。転置は要素に再帰的に適用されることに注意してください。

この操作は線形代数の使用を意図しています - 一般的なデータ操作については [`permutedims`](@ref Base.permutedims) を参照してください。これは再帰的ではありません。

# 例

```jldoctest
julia> A = [1 2im; -3im 4]
2×2 Matrix{Complex{Int64}}:
 1+0im  0+2im
 0-3im  4+0im

julia> T = transpose(A)
2×2 transpose(::Matrix{Complex{Int64}}) with eltype Complex{Int64}:
 1+0im  0-3im
 0+2im  4+0im

julia> copy(T)
2×2 Matrix{Complex{Int64}}:
 1+0im  0-3im
 0+2im  4+0im
```
