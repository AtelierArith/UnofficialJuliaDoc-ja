```julia
scal!(n, a, X, incx)
scal!(a, X)
```

配列 `X` の先頭 `n` 個の要素を、ストライド `incx` で `X` から `a*X` に上書きします。`X` を返します。

`n` と `incx` が指定されていない場合は、`length(X)` と `stride(X,1)` が使用されます。
