```julia
scal!(n, a, X, incx)
scal!(a, X)
```

配列 `X` の最初の `n` 要素を `a*X` で上書きし、ストライドは `incx` です。`X` を返します。

`n` と `incx` が指定されていない場合は、`length(X)` と `stride(X,1)` が使用されます。
