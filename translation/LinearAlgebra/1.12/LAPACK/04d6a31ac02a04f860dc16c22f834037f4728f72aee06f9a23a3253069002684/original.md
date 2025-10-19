```julia
trexc!(compq, ifst, ilst, T, Q) -> (T, Q)
trexc!(ifst, ilst, T, Q) -> (T, Q)
```

Reorder the Schur factorization `T` of a matrix, such that the diagonal block of `T` with row index `ifst` is moved to row index `ilst`. If `compq = V`, the Schur vectors `Q` are reordered. If `compq = N` they are not modified. The 4-arg method calls the 5-arg method with `compq = V`.
