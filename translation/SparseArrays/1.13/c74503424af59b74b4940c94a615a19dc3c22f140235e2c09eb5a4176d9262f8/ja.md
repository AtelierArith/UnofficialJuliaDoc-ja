```julia
SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
```

[Compressed Sparse Column](@ref man-csc)形式の疎行列を格納するための行列型です。SparseMatrixCSCは通常、[`sparse`](@ref)関数を使って構築します。[`spzeros`](@ref)、[`spdiagm`](@ref)、[`sprand`](@ref)も参照してください。
