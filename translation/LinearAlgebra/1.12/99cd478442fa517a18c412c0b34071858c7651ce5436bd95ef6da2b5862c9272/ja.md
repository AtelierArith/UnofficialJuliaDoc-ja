```julia
schur!(A) -> F::Schur
```

[`schur`](@ref)と同様ですが、入力引数`A`を作業領域として使用します。

# 例

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> F = schur!(A)
Schur{Float64, Matrix{Float64}, Vector{Float64}}
T因子:
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
Z因子:
2×2 Matrix{Float64}:
  0.961524  0.274721
 -0.274721  0.961524
固有値:
2要素 Vector{Float64}:
  3.0
 -2.0

julia> A
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
```
