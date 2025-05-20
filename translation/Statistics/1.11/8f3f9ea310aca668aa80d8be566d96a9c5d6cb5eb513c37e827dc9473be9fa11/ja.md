```
cov(x::AbstractVector, y::AbstractVector; corrected::Bool=true)
```

ベクトル `x` と `y` の共分散を計算します。`corrected` が `true`（デフォルト）である場合、$\frac{1}{n-1}\sum_{i=1}^n (x_i-\bar x) (y_i-\bar y)^*$ を計算します。ここで、$*$ は複素共役を示し、`n = length(x) = length(y)` です。`corrected` が `false` の場合、$\frac{1}{n}\sum_{i=1}^n (x_i-\bar x) (y_i-\bar y)^*$ を計算します。
