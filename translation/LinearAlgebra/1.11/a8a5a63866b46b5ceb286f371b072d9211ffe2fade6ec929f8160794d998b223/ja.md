```
MulAddMul(alpha, beta)
```

`x * alpha + y * beta` の短絡バージョンを操作するための呼び出し可能な関数です。

# 例

```jldoctest
julia> using LinearAlgebra: MulAddMul

julia> _add = MulAddMul(1, 0);

julia> _add(123, nothing)
123

julia> MulAddMul(12, 34)(56, 78) == 56 * 12 + 78 * 34
true
```
