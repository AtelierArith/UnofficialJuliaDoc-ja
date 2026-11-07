```julia
_modify!(_add::MulAddMul, x, C, idx)
```

`C[idx] = _add(x, C[idx])` の短絡評価版。

`C[idx]` のインデックス指定を短絡評価することで、`BigFloat` のような非プリミティブ数値の配列を変更する際に `UndefRefError` が発生するのを防げます。

# Examples

```jldoctest
julia> using LinearAlgebra: MulAddMul, _modify!

julia> _add = MulAddMul(1, 0);
       C = Vector{BigFloat}(undef, 1);

julia> _modify!(_add, 123, C, 1)

julia> C
1-element Vector{BigFloat}:
 123.0
```
