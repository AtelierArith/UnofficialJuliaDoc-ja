```julia
median(f, v)
```

コレクション `v` の各要素に関数 `f` を適用し、その後、中央値を計算します。

```jldoctest
julia> using Statistics

julia> median(√, [1, 3, 2])
1.4142135623730951

julia> median([√1, √3, √2])
1.4142135623730951
```
