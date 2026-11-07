```julia
cov(X::AbstractMatrix; dims::Int=1, corrected::Bool=true)
```

行列 `X` の共分散行列を、次元 `dims` に沿って計算します。`corrected` が `true`（デフォルト）の場合、和は `n-1` でスケーリングされます。一方、`corrected` が `false`（`n = size(X, dims)` の場合）なら、和は `n` でスケーリングされます。
