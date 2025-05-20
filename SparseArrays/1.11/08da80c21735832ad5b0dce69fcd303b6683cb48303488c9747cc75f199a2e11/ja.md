```
unwrap(A::AbstractMatrix)
```

Aがラッパー型（`SubArray, Symmetric, Adjoint, SubArray, Triangular, Tridiagonal`など）の場合、Aの最終的なストレージタイプに応じて`Matrix`または`SparseMatrixCSC`に変換します。他のタイプの場合はA自体を返します。
