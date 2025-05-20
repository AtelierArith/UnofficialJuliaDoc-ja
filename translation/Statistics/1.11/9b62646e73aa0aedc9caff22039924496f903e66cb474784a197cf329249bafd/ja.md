```
cov(x::AbstractVector; corrected::Bool=true)
```

ベクトル `x` の分散を計算します。`corrected` が `true`（デフォルト）であれば、合計は `n-1` でスケーリングされますが、`corrected` が `false` の場合は合計は `n` でスケーリングされます。ここで、`n = length(x)` です。
