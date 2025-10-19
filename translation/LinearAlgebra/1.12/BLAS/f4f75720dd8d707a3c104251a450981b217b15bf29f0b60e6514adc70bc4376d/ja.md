```julia
rot!(n, X, incx, Y, incy, c, s)
```

配列 `X` の最初の `n` 要素を `c*X + s*Y` で上書きし、配列 `Y` の最初の `n` 要素を `-conj(s)*X + c*Y` で上書きします。ストライドはそれぞれ `incx` と `incy` です。`X` と `Y` を返します。

!!! compat "Julia 1.5"
    `rot!` は少なくとも Julia 1.5 が必要です。

