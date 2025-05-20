```
_modify!(_add::MulAddMul, x, C, idx)
```

Short-circuiting version of `C[idx] = _add(x, C[idx])`.

Short-circuiting the indexing `C[idx]` is necessary for avoiding `UndefRefError` when mutating an array of non-primitive numbers such as `BigFloat`.

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
