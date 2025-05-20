```
ntuple(f, n::Integer)
```

長さ `n` のタプルを作成し、各要素を `f(i)` として計算します。ここで、`i` は要素のインデックスです。

# 例

```jldoctest
julia> ntuple(i -> 2*i, 4)
(2, 4, 6, 8)
```
