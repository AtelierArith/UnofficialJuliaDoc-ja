```
copymutable_oftype(A, T)
```

Copy `A` to a mutable array with eltype `T` based on `similar(A, T)`.

The resulting matrix typically has similar algebraic structure as `A`. For example, supplying a tridiagonal matrix results in another tridiagonal matrix. In general, the type of the output corresponds to that of `similar(A, T)`.

In LinearAlgebra, mutable copies (of some desired eltype) are created to be passed to in-place algorithms (such as `ldiv!`, `rdiv!`, `lu!` and so on). If the specific algorithm is known to preserve the algebraic structure, use `copymutable_oftype`. If the algorithm is known to return a dense matrix (or some wrapper backed by a dense matrix), then use `copy_similar`.

See also: `Base.copymutable`, `copy_similar`.
