```julia
scal(n, a, X, incx)
scal(a, X)
```

配列 `X` の最初の `n` 要素をストライド `incx` で `a` でスケーリングした `X` を返します。

`n` と `incx` が指定されていない場合、`length(X)` と `stride(X,1)` が使用されます。
