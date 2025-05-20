```
quantile!([q::AbstractArray, ] v::AbstractVector, p; sorted=false, alpha::Real=1.0, beta::Real=alpha)
```

ベクトル `v` の指定された確率または確率のベクトルまたはタプル `p` における分位数を計算します。`p` がベクトルの場合、オプションの出力配列 `q` も指定できます。（提供されない場合、新しい出力配列が作成されます。）キーワード引数 `sorted` は、`v` がソートされていると仮定できるかどうかを示します。`false`（デフォルト）の場合、`v` の要素はインプレースで部分的にソートされます。

サンプル分位数は `Q(p) = (1-γ)*x[j] + γ*x[j+1]` によって定義され、ここで `x[j]` は `v` の j 番目の順序統計量であり、`j = floor(n*p + m)`、`m = alpha + p*(1 - alpha - beta)` および `γ = n*p + m - j` です。

デフォルトでは（`alpha = beta = 1`）、分位数は点 `((k-1)/(n-1), x[k])` の間の線形補間を介して計算されます。ここで `k = 1:n` であり、`n = length(v)` です。これは Hyndman と Fan (1996) の定義 7 に対応し、R および NumPy のデフォルトと同じです。

キーワード引数 `alpha` と `beta` は、Hyndman と Fan の同じパラメータに対応しており、異なる値に設定することで、この論文で定義された方法 4-9 のいずれかを使用して分位数を計算できます：

  * 定義 4: `alpha=0`, `beta=1`
  * 定義 5: `alpha=0.5`, `beta=0.5`（MATLAB デフォルト）
  * 定義 6: `alpha=0`, `beta=0`（Excel `PERCENTILE.EXC`、Python デフォルト、Stata `altdef`）
  * 定義 7: `alpha=1`, `beta=1`（Julia、R および NumPy デフォルト、Excel `PERCENTILE` および `PERCENTILE.INC`、Python `'inclusive'`）
  * 定義 8: `alpha=1/3`, `beta=1/3`
  * 定義 9: `alpha=3/8`, `beta=3/8`

!!! note
    `v` に `NaN` または [`missing`](@ref) 値が含まれている場合、`ArgumentError` がスローされます。


# 参考文献

  * Hyndman, R.J と Fan, Y. (1996) "Sample Quantiles in Statistical Packages", *The American Statistician*, Vol. 50, No. 4, pp. 361-365
  * [Quantile on Wikipedia](https://en.m.wikipedia.org/wiki/Quantile) では異なる分位数の定義について詳しく説明しています

# 例

```jldoctest
julia> using Statistics

julia> x = [3, 2, 1];

julia> quantile!(x, 0.5)
2.0

julia> x
3-element Vector{Int64}:
 1
 2
 3

julia> y = zeros(3);

julia> quantile!(y, x, [0.1, 0.5, 0.9]) === y
true

julia> y
3-element Vector{Float64}:
 1.2000000000000002
 2.0
 2.8000000000000003
```
