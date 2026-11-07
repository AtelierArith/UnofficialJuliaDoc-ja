```julia
mean(itr)
```

コレクション内のすべての要素の平均を計算します。

!!! note
    `itr` に `NaN` または [`missing`](@ref) の値が含まれている場合、結果も `NaN` または `missing` になります（配列に両方が含まれる場合は `missing` が優先されます）。[`skipmissing`](@ref) 関数を使うと、`missing` の要素を除外して、欠損値以外の値の平均を計算できます。


# Examples

```jldoctest
julia> using Statistics

julia> mean(1:20)
10.5

julia> mean([1, missing, 3])
missing

julia> mean(skipmissing([1, missing, 3]))
2.0
```
