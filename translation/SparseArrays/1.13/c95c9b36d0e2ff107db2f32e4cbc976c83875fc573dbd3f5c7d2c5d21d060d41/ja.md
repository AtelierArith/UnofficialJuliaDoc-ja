```julia
unwrap(A::AbstractMatrix)
```

A がラッパー型（`SubArray, Symmetric, Adjoint, SubArray, Triangular, Tridiagonal` など）の場合は、A の最終的な格納型に応じて `Matrix` または `SparseMatrixCSC` に変換します。それ以外の型の場合は、A 自体を返します。
