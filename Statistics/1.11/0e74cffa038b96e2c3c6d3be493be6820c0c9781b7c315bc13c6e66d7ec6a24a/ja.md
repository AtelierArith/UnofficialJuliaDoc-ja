```julia
varm(itr, mean; dims, corrected::Bool=true)
```

平均値 `mean` が既知の場合に、コレクション `itr` の標本分散を計算します。

このアルゴリズムは、`itr` の各要素が、同じ未知の分布から抽出された無相関な標本であると仮定し、生成分布の分散の推定量を返します。配列の場合、この計算は `sum(abs2.(itr .- mean(itr))) / (length(itr) - 1)` の計算と同等です。`corrected` が `true` の場合、和は `n-1` でスケーリングされます。一方、`corrected` が `false` で、`n` が `itr` の要素数である場合、和は `n` でスケーリングされます。

`itr` が `AbstractArray` の場合、次元ごとの分散を計算するために `dims` を指定できます。この場合、`mean` は `mean(itr, dims=dims)` と同じ形状の配列である必要があります（末尾に追加される単一要素の次元は許容されます）。

!!! note
    配列に `NaN` または [`missing`](@ref) の値が含まれる場合、結果も `NaN` または `missing` になります（両方が含まれる場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使うと、`missing` の要素を除外し、欠損値以外の値の分散を計算できます。

