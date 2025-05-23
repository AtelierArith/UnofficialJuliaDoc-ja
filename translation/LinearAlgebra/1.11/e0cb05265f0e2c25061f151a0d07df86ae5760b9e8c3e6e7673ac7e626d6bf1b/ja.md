```
cos(A::AbstractMatrix)
```

正方行列 `A` の行列コサインを計算します。

`A` が対称またはエルミートの場合、その固有分解（[`eigen`](@ref)）を使用してコサインを計算します。そうでない場合、コサインは [`exp`](@ref) を呼び出すことによって決定されます。

# 例

```jldoctest
julia> cos(fill(1.0, (2,2)))
2×2 Matrix{Float64}:
  0.291927  -0.708073
 -0.708073   0.291927
```
