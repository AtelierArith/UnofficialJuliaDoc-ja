```julia
median(itr)
```

コレクション内のすべての要素の中央値を計算します。要素数が偶数の場合、中央値に正確に対応する要素は存在しないため、結果は中央の2要素の平均を計算した値と等しくなります。

!!! note
    `itr` に `NaN` または [`missing`](@ref) の値が含まれる場合、結果も `NaN` または `missing` になります（`itr` に両方が含まれる場合は、`missing` が優先されます）。`missing` の要素を除外して欠損していない値の中央値を計算するには、[`skipmissing`](@ref) 関数を使用してください。


# Examples

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
