```julia
@horner(x, p...)
```

`p[1] + x * (p[2] + x * (....))`を評価します。つまり、ホーナー法で多項式を評価します。

[`@evalpoly`](@ref)、[`evalpoly`](@ref)も参照してください。
