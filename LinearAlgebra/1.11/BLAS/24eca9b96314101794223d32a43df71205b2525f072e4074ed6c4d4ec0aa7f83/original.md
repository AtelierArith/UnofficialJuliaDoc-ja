```
scal(n, a, X, incx)
scal(a, X)
```

Return `X` scaled by `a` for the first `n` elements of array `X` with stride `incx`.

If `n` and `incx` are not provided, `length(X)` and `stride(X,1)` are used.
