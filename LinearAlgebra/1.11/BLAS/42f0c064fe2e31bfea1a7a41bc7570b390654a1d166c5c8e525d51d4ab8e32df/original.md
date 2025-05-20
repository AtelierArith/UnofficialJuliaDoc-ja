```
rot!(n, X, incx, Y, incy, c, s)
```

Overwrite `X` with `c*X + s*Y` and `Y` with `-conj(s)*X + c*Y` for the first `n` elements of array `X` with stride `incx` and first `n` elements of array `Y` with stride `incy`. Returns `X` and `Y`.

!!! compat "Julia 1.5"
    `rot!` requires at least Julia 1.5.

