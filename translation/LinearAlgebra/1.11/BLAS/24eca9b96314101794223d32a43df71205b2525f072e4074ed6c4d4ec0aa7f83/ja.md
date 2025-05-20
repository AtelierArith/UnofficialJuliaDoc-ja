```
scal(n, a, X, incx)
scal(a, X)
```

配列 `X` の最初の `n` 要素をストライド `incx` で `a` でスケーリングします。

`n` と `incx` が指定されていない場合は、`length(X)` と `stride(X,1)` が使用されます。
