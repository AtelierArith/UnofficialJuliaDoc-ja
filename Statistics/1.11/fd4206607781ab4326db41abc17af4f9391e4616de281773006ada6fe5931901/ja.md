```
cov(X::AbstractMatrix; dims::Int=1, corrected::Bool=true)
```

行列 `X` の共分散行列を次元 `dims` に沿って計算します。`corrected` が `true`（デフォルト）であれば、合計は `n-1` でスケーリングされますが、`corrected` が `false` の場合は合計は `n` でスケーリングされます。ここで、`n = size(X, dims)` です。
