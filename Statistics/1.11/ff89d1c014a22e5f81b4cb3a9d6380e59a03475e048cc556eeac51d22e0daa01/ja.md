```julia
cov(X::AbstractVecOrMat, Y::AbstractVecOrMat; dims::Int=1, corrected::Bool=true)
```

ベクトルまたは行列 `X` と `Y` の間の共分散を、次元 `dims` に沿って計算します。`corrected` がデフォルトの `true` の場合、合計は `n-1` でスケーリングされます。一方、`corrected` が `false` であり、`n = size(X, dims) = size(Y, dims)` の場合は、合計は `n` でスケーリングされます。
