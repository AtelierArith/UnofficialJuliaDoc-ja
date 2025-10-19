```julia
stdm(itr, mean; corrected::Bool=true[, dims])
```

コレクション `itr` のサンプル標準偏差を、既知の平均 `mean` で計算します。

このアルゴリズムは、`itr` の各エントリが同じ未知の分布から抽出されたサンプルであり、サンプルが無相関であるという仮定の下で、生成分布の標準偏差の推定量を返します。配列の場合、この計算は `sqrt.(sum(abs2.(itr .- mean(itr))) / (length(itr) - 1))` を計算することと同等です。`corrected` が `true` の場合、合計は `n-1` でスケーリングされますが、`corrected` が `false` の場合は合計は `n` でスケーリングされ、ここで `n` は `itr` の要素数です。

`itr` が `AbstractArray` の場合、次元に対して標準偏差を計算するために `dims` を指定できます。その場合、`mean` は `mean(itr, dims=dims)` と同じ形状の配列でなければなりません（追加のトレーリングシングルトン次元は許可されます）。

!!! note
    配列に `NaN` または [`missing`](@ref) 値が含まれている場合、結果も `NaN` または `missing` になります（配列に両方が含まれている場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使用して `missing` エントリを省略し、非欠損値の標準偏差を計算します。

