```julia
LinearAlgebra.eigencopy_oftype(A::AbstractMatrix, ::Type{S})
```

`A`の密なコピーを、`S`を要素型として作成します。作成には`copy_similar(A, S)`を呼び出します。`Hermitian`または`Symmetric`行列の場合は、`uplo`フィールドとともにラッパーも保持します。
