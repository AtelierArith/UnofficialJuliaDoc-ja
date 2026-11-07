```julia
LinearAlgebra.eigencopy_oftype(A::AbstractMatrix, ::Type{S})
```

`A` の密なコピーを、`copy_similar(A, S)` を呼び出して作成します。コピーの eltype は `S` です。`Hermitian` または `Symmetric` 行列の場合は、`uplo` フィールドとともにラッパーも保持します。
