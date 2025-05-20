```
setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
```

指定された `base` の間、`f` のために `T` の算術精度を変更します。これは論理的に次のように等価です：

```
old = precision(BigFloat)
setprecision(BigFloat, precision)
f()
setprecision(BigFloat, old)
```

しばしば `setprecision(T, precision) do ... end` のように使用されます。

注意：`nextfloat()`、`prevfloat()` は `setprecision` によって言及された精度を使用しません。

!!! compat "Julia 1.8"
    `base` キーワードは少なくとも Julia 1.8 を必要とします。

