```julia
scal(n, a, X, incx)
scal(a, X)
```

配列 `X` の先頭から `n` 個の要素を、ストライド `incx` で取り出し、`a` 倍して `X` を返します。

`n` と `incx` が指定されていない場合は、`length(X)` と `stride(X,1)` が使用されます。
