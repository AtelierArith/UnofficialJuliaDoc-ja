```julia
setprecision(f::Function, [T=BigFloat,] precision::Integer; base=2)
```

`f`の実行中に限り、`T`の算術精度を（指定された`base`で）変更します。これは論理的には次と同等です。

```julia
old = precision(BigFloat)
setprecision(BigFloat, precision)
f()
setprecision(BigFloat, old)
```

`setprecision(T, precision) do ... end`としてよく使われます。

注: `nextfloat()`と`prevfloat()`は、`setprecision`で指定された精度を使用しません。

!!! warning
    このメソッドには、`precision`と`setprecision`を呼び出すフォールバック実装がありますが、今後はこれに依存しないでください。代わりに、`ScopedValue`を使用する形で3引数版を直接定義するか、呼び出し側で`ScopedValue`と`@with`を使うよう推奨してください。


!!! compat "Julia 1.8"
    `base`キーワードを使用するには、Julia 1.8以降が必要です。

