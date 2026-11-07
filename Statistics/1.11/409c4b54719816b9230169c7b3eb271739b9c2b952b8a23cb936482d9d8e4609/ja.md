```julia
var(itr; corrected::Bool=true, mean=nothing[, dims])
```

コレクション `itr` の標本分散を計算します。

このアルゴリズムは、`itr` の各要素が、同じ未知の分布から抽出された互いに無相関な標本であると仮定し、生成分布の分散の推定量を返します。配列の場合、この計算は `sum(abs2.(itr .- mean(itr))) / (length(itr) - 1)` の計算と同等です。`corrected` が `true` の場合、合計値には `n-1` が乗じられます。一方、`corrected` が `false` の場合は、合計値に `n` が乗じられます。ここで、`n` は `itr` の要素数です。

`itr` が `AbstractArray` の場合、次元ごとの分散を計算するために `dims` を指定できます。

事前に計算した `mean` を指定することもできます。`dims` を指定する場合、`mean` は `mean(itr, dims=dims)` と同じ形状の配列でなければなりません（末尾に追加される次元が単一要素の次元であれば許容されます）。

!!! note
    配列に `NaN` または [`missing`](@ref) の値が含まれる場合、結果も `NaN` または `missing` になります（両方が含まれる場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使うと、`missing` の要素を除外し、欠損値以外の値の分散を計算できます。

