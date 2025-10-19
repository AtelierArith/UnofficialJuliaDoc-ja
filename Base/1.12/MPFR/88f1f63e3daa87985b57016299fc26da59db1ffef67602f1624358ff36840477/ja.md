```julia
setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
```

指定された `base` の間、`f` のために `T` の算術精度を変更します。これは論理的に次のように等価です：

```julia
old = precision(BigFloat)
setprecision(BigFloat, precision)
f()
setprecision(BigFloat, old)
```

しばしば `setprecision(T, precision) do ... end` のように使用されます。

注意: `nextfloat()`, `prevfloat()` は `setprecision` で言及された精度を使用しません。

!!! warning
    このメソッドのフォールバック実装があり、`precision` と `setprecision` を呼び出しますが、もはや依存すべきではありません。代わりに、`ScopedValue` を使用する方法で3引数形式を直接定義するか、呼び出し元が自分で `ScopedValue` と `@with` を使用することを推奨してください。


!!! compat "Julia 1.8"
    `base` キーワードは少なくとも Julia 1.8 を必要とします。

