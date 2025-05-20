```
cov(X::AbstractVecOrMat, Y::AbstractVecOrMat; dims::Int=1, corrected::Bool=true)
```

ベクトルまたは行列 `X` と `Y` の間の共分散を次元 `dims` に沿って計算します。`corrected` が `true`（デフォルト）である場合、合計は `n-1` でスケーリングされますが、`corrected` が `false` の場合は合計は `n` でスケーリングされます。ここで、`n = size(X, dims) = size(Y, dims)` です。
