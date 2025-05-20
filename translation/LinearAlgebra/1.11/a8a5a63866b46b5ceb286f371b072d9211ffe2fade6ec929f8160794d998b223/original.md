```
MulAddMul(alpha, beta)
```

A callable for operating short-circuiting version of `x * alpha + y * beta`.

# Examples

```jldoctest
julia> using LinearAlgebra: MulAddMul

julia> _add = MulAddMul(1, 0);

julia> _add(123, nothing)
123

julia> MulAddMul(12, 34)(56, 78) == 56 * 12 + 78 * 34
true
```
