```
(I::UniformScaling)(n::Integer)
```

`UniformScaling`から`Diagonal`行列を構築します。

!!! compat "Julia 1.2"
    このメソッドはJulia 1.2以降で利用可能です。


# 例

```jldoctest
julia> I(3)
3×3 Diagonal{Bool, Vector{Bool}}:
 1  ⋅  ⋅
 ⋅  1  ⋅
 ⋅  ⋅  1

julia> (0.7*I)(3)
3×3 Diagonal{Float64, Vector{Float64}}:
 0.7   ⋅    ⋅
  ⋅   0.7   ⋅
  ⋅    ⋅   0.7
```
