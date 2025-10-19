```julia
median(itr)
```

コレクション内のすべての要素の中央値を計算します。要素数が偶数の場合、正確な中央値の要素は存在しないため、結果は2つの中央値の要素の平均を計算することに相当します。

!!! note
    `itr` に `NaN` または [`missing`](@ref) 値が含まれている場合、結果も `NaN` または `missing` になります（`itr` に両方が含まれている場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使用して `missing` エントリを省略し、非 `missing` 値の中央値を計算します。


# 例

```jldoctest
julia> using Statistics

julia> median([1, 2, 3])
2.0

julia> median([1, 2, 3, 4])
2.5

julia> median([1, 2, missing, 4])
missing

julia> median(skipmissing([1, 2, missing, 4]))
2.0
```
