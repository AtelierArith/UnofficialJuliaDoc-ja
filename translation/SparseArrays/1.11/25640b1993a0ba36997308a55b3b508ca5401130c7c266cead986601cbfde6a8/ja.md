```
sparsevec(d::Dict, [m])
```

辞書のキーから非ゼロインデックスを持ち、辞書の値から非ゼロ値を持つ長さ `m` のスパースベクトルを作成します。

# 例

```jldoctest
julia> sparsevec(Dict(1 => 3, 2 => 2))
2-element SparseVector{Int64, Int64} with 2 stored entries:
  [1]  =  3
  [2]  =  2
```
