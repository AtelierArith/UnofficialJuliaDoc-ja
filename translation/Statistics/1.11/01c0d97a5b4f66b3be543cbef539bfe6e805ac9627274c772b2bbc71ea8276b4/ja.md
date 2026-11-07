```julia
std(itr; corrected::Bool=true, mean=nothing[, dims])
```

コレクション `itr` の標本標準偏差を計算します。

このアルゴリズムは、`itr` の各要素が、互いに無相関な、同一の未知の分布から得られた標本であると仮定し、その生成分布の標準偏差の推定値を返します。配列の場合、この計算は `sqrt.(sum(abs2.(itr .- mean(itr))) / (length(itr) - 1))` の計算と同等です。`corrected` が `true` の場合、和には `n-1` が乗じられます。一方、`corrected` が `false` の場合、和には `n` が乗じられます。このとき、`n` は `itr` の要素数です。

`itr` が `AbstractArray` の場合、次元ごとの標準偏差を計算するために `dims` を指定できます。

事前に計算した `mean` を指定することもできます。`dims` を指定する場合、`mean` は `mean(itr, dims=dims)` と同じ形状の配列でなければなりません（末尾に追加される次元が 1 の場合は許容されます）。

!!! note
    配列に `NaN` または [`missing`](@ref) の値が含まれる場合、結果にも `NaN` または `missing` が含まれます（両方が含まれる場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使うと、`missing` の要素を除外し、欠損値以外の値の標準偏差を計算できます。

