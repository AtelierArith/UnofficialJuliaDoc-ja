```julia
skipmissing(itr)
```

`itr` の要素を、[`missing`](@ref) の値を除いて返すイテレーターです。返されるオブジェクトは、`itr` がインデックス可能であれば、そのインデックスを使ってインデックス指定できます。欠損値に対応するインデックスは無効です。[`keys`](@ref) と [`eachindex`](@ref) ではスキップされ、使用しようとすると `MissingException` がスローされます。

[`collect`](@ref) を使うと、`itr` に含まれる `missing` 以外の値を格納した `Array` を取得できます。`itr` が多次元配列であっても、結果は常に `Vector` になります。入力の次元を保ったまま欠損値を取り除くことはできないためです。

関連項目: [`coalesce`](@ref)、[`ismissing`](@ref)、[`something`](@ref)。

# Examples

```jldoctest
julia> x = skipmissing([1, missing, 2])
skipmissing(Union{Missing, Int64}[1, missing, 2])

julia> sum(x)
3

julia> x[1]
1

julia> x[2]
ERROR: MissingException: the value at index (2,) is missing
[...]

julia> argmax(x)
3

julia> collect(keys(x))
2-element Vector{Int64}:
 1
 3

julia> collect(skipmissing([1, missing, 2]))
2-element Vector{Int64}:
 1
 2

julia> collect(skipmissing([1 missing; 2 missing]))
2-element Vector{Int64}:
 1
 2
```
