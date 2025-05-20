```
mean(itr)
```

コレクション内のすべての要素の平均を計算します。

!!! note
    `itr` に `NaN` または [`missing`](@ref) 値が含まれている場合、結果も `NaN` または `missing` になります（配列に両方が含まれている場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使用して `missing` エントリを省略し、非 `missing` 値の平均を計算します。


# 例

```jldoctest
julia> using Statistics

julia> mean(1:20)
10.5

julia> mean([1, missing, 3])
missing

julia> mean(skipmissing([1, missing, 3]))
2.0
```
