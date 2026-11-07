```julia
rot!(n, X, incx, Y, incy, c, s)
```

配列 `X` の先頭 `n` 個の要素（ストライド `incx`）と、配列 `Y` の先頭 `n` 個の要素（ストライド `incy`）について、`X` を `c*X + s*Y` で、`Y` を `-conj(s)*X + c*Y` で上書きします。`X` と `Y` を返します。

!!! compat "Julia 1.5"
    `rot!` には Julia 1.5 以降が必要です。

