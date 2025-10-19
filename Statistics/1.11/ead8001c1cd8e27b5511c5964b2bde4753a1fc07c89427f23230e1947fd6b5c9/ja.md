```julia
varm(itr, mean; dims, corrected::Bool=true)
```

コレクション `itr` のサンプル分散を、既知の平均 `mean` で計算します。

このアルゴリズムは、`itr` の各エントリが同じ未知の分布から抽出されたサンプルであり、サンプルが無相関であるという仮定の下で、生成分布の分散の推定量を返します。配列の場合、この計算は `sum(abs2.(itr .- mean(itr))) / (length(itr) - 1)` を計算することと同等です。`corrected` が `true` の場合、合計は `n-1` でスケーリングされ、`corrected` が `false` の場合は `n` でスケーリングされます。ここで、`n` は `itr` の要素数です。

`itr` が `AbstractArray` の場合、次元に対して分散を計算するために `dims` を指定できます。その場合、`mean` は `mean(itr, dims=dims)` と同じ形状の配列でなければなりません（追加の末尾の単一次元は許可されます）。

!!! note
    配列に `NaN` または [`missing`](@ref) 値が含まれている場合、結果も `NaN` または `missing` になります（配列に両方が含まれている場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使用して `missing` エントリを省略し、非欠損値の分散を計算してください。

