```
mean(f, itr)
```

コレクション `itr` の各要素に関数 `f` を適用し、平均を取ります。

```jldoctest
julia> using Statistics

julia> mean(√, [1, 2, 3])
1.3820881233139908

julia> mean([√1, √2, √3])
1.3820881233139908
```
