```
SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
```

疎行列を[圧縮スパース列](@ref man-csc)形式で格納するための行列タイプ。SparseMatrixCSCを構築する標準的な方法は、[`sparse`](@ref)関数を通じてです。[`spzeros`](@ref)、[`spdiagm`](@ref)、および[`sprand`](@ref)も参照してください。
