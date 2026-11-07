```julia
cov(x::AbstractVector; corrected::Bool=true)
```

ベクトル `x` の分散を計算します。`corrected` が `true`（デフォルト）の場合、合計は `n-1` でスケーリングされます。一方、`corrected` が `false`（`n = length(x)`）の場合、合計は `n` でスケーリングされます。
