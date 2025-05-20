```
cis(x)
```

オイラーの公式を使用した `exp(im*x)` のより効率的な方法: $\cos(x) + i \sin(x) = \exp(i x)$。

関連項目としては [`cispi`](@ref), [`sincos`](@ref), [`exp`](@ref), [`angle`](@ref) があります。

# 例

```jldoctest
julia> cis(π) ≈ -1
true
```
