```
LinearAlgebra.eigencopy_oftype(A::AbstractMatrix, ::Type{S})
```

Creates a dense copy of `A` with eltype `S` by calling `copy_similar(A, S)`. In the case of `Hermitian` or `Symmetric` matrices additionally retains the wrapper, together with the `uplo` field.
