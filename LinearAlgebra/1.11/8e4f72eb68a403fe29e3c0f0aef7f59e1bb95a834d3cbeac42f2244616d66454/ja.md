```
_modify!(_add::MulAddMul, x, C, idx)
```

`C[idx] = _add(x, C[idx])` のショートサーキットバージョンです。

`C[idx]` のインデックスをショートサーキットすることは、`BigFloat` のような非プリミティブ数の配列を変更する際に `UndefRefError` を避けるために必要です。

# 例

```jldoctest
julia> using LinearAlgebra: MulAddMul, _modify!

julia> _add = MulAddMul(1, 0);
       C = Vector{BigFloat}(undef, 1);

julia> _modify!(_add, 123, C, 1)

julia> C
1-element Vector{BigFloat}:
 123.0
```
