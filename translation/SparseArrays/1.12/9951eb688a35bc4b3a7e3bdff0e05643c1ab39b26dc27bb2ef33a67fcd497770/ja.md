```julia
SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
```

[Compressed Sparse Column](@ref man-csc) 形式でスパース行列を格納するための行列タイプです。SparseMatrixCSCを構築する標準的な方法は、[`sparse`](@ref) 関数を通じてです。[`spzeros`](@ref)、[`spdiagm`](@ref)、および [`sprand`](@ref) も参照してください。
