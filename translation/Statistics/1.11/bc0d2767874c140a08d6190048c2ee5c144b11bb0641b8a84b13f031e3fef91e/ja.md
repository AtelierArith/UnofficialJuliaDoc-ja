```julia
quantile(itr, p; sorted=false, alpha::Real=1.0, beta::Real=alpha)
```

指定した確率、または確率のベクトルやタプル `p`（区間 [0,1] 内）における、コレクション `itr` の分位点を計算します。キーワード引数 `sorted` は、`itr` がソート済みとみなせるかどうかを指定します。

標本分位点は `Q(p) = (1-γ)*x[j] + γ*x[j+1]` で定義されます。ここで、`x[j]` は `itr` の第 j 順序統計量であり、`j = floor(n*p + m)`、`m = alpha + p*(1 - alpha - beta)`、`γ = n*p + m - j` です。

デフォルト（`alpha = beta = 1`）では、`((k-1)/(n-1), x[k])` の点の間を線形補間して分位点を計算します。ただし、`k = 1:n` であり、`n = length(itr)` です。これは Hyndman と Fan（1996）の定義 7 に相当し、R および NumPy のデフォルトと同じです。

キーワード引数 `alpha` と `beta` は、Hyndman と Fan が用いた同名のパラメーターに対応します。これらに異なる値を設定すると、同論文で定義された方法 4〜9 のいずれかで分位点を計算できます。

  * 定義 4: `alpha=0`、`beta=1`
  * 定義 5: `alpha=0.5`、`beta=0.5`（MATLAB のデフォルト）
  * 定義 6: `alpha=0`、`beta=0`（Excel `PERCENTILE.EXC`、Python のデフォルト、Stata `altdef`）
  * 定義 7: `alpha=1`、`beta=1`（Julia、R、NumPy のデフォルト、Excel `PERCENTILE` および `PERCENTILE.INC`、Python `'inclusive'`）
  * 定義 8: `alpha=1/3`、`beta=1/3`
  * 定義 9: `alpha=3/8`、`beta=3/8`

!!! note
    `v` に `NaN` または [`missing`](@ref) の値が含まれている場合、`ArgumentError` がスローされます。[`skipmissing`](@ref) 関数を使って `missing` のエントリーを除外し、欠損値以外の値の分位点を計算してください。


# References

  * Hyndman, R.J. および Fan, Y.（1996）「統計パッケージにおける標本分位点」、『The American Statistician』第 50 巻第 4 号、361–365 ページ
  * [Quantile on Wikipedia](https://en.wikipedia.org/wiki/Quantile) では、各種の分位点の定義について詳しく説明しています。

# Examples

```jldoctest
julia> using Statistics

julia> quantile(0:20, 0.5)
10.0

julia> quantile(0:20, [0.1, 0.5, 0.9])
3-element Vector{Float64}:
  2.0
 10.0
 18.0

julia> quantile(skipmissing([1, 10, missing]), 0.5)
5.5
```
