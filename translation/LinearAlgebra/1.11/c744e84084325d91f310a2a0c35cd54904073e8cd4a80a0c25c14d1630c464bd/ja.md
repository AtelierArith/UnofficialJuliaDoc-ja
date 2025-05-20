```
LinearAlgebra.eigencopy_oftype(A::AbstractMatrix, ::Type{S})
```

`A`の密なコピーを型`S`で作成します。これは`copy_similar(A, S)`を呼び出すことによって行われます。`Hermitian`または`Symmetric`行列の場合、ラッパーと`uplo`フィールドも保持されます。
