```julia
rank(S::SparseMatrixCSC{Tv,Ti}; [tol::Real]) -> Ti
```

Calculate rank of `S` by calculating its QR factorization. Values smaller than `tol` are considered as zero. See SPQR's manual.
