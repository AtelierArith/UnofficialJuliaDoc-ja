```julia
quantile!([q::AbstractArray, ] v::AbstractVector, p; sorted=false, alpha::Real=1.0, beta::Real=alpha)
```

確率または確率のベクトル・タプル `p`（区間 [0,1] 内）を指定して、ベクトル `v` の分位点を計算します。`p` がベクトルの場合は、出力配列 `q` も指定できます（省略すると、新しい出力配列が作成されます）。キーワード引数 `sorted` は、`v` がソート済みとみなせるかどうかを指定します。`false`（デフォルト）の場合、`v` の要素はインプレースで部分ソートされます。

標本分位点は `Q(p) = (1-γ)*x[j] + γ*x[j+1]` で定義されます。ここで、`x[j]` は `v` の第 j 順序統計量であり、`j = floor(n*p + m)` および `m = alpha + p*(1 - alpha - beta)`、`γ = n*p + m - j` です。

デフォルト（`alpha = beta = 1`）では、`((k-1)/(n-1), x[k])` の点の間を線形補間して分位点を計算します。これは `k = 1:n` に対して `n = length(v)` の場合に適用されます。Hyndman と Fan (1996) の定義 7 に相当し、R および NumPy のデフォルトと同じです。

キーワード引数 `alpha` と `beta` は、Hyndman と Fan の同名のパラメーターに対応します。これらに異なる値を設定すると、同論文で定義された方法 4〜9 のいずれかで分位点を計算できます。

  * 定義 4: `alpha=0`、`beta=1`
  * 定義 5: `alpha=0.5`、`beta=0.5`（MATLAB のデフォルト）
  * 定義 6: `alpha=0`、`beta=0`（Excel `PERCENTILE.EXC`、Python のデフォルト、Stata `altdef`）
  * 定義 7: `alpha=1`、`beta=1`（Julia、R、NumPy のデフォルト、Excel `PERCENTILE` および `PERCENTILE.INC`、Python `'inclusive'`）
  * 定義 8: `alpha=1/3`、`beta=1/3`
  * 定義 9: `alpha=3/8`、`beta=3/8`

!!! note
    `v` に `NaN` または [`missing`](@ref) の値が含まれている場合、`ArgumentError` がスローされます。


# References

  * Hyndman, R.J. および Fan, Y. (1996)「統計パッケージにおける標本分位点」*The American Statistician*, Vol. 50, No. 4, pp. 361–365
  * [Quantile on Wikipedia](https://en.wikipedia.org/wiki/Quantile) では、さまざまな分位点の定義について詳しく説明しています。

# Examples

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
 1.2
 2.0
 2.8
```
