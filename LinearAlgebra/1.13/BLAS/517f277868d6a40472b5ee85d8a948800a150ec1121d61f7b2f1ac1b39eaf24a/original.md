```julia
scal!(n, a, X, incx)
scal!(a, X)
```

Overwrite `X` with `a*X` for the first `n` elements of array `X` with stride `incx`. Returns `X`.

If `n` and `incx` are not provided, `length(X)` and `stride(X,1)` are used.
