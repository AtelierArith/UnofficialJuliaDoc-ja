```julia
copy(A::Transpose)
copy(A::Adjoint)
```

遅延評価される行列の転置／随伴を即時評価します。転置は要素にも再帰的に適用されることに注意してください。

この操作は線形代数での使用を想定しています。一般的なデータ操作には、再帰的ではない[`permutedims`](@ref Base.permutedims)を参照してください。

# Examples

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
