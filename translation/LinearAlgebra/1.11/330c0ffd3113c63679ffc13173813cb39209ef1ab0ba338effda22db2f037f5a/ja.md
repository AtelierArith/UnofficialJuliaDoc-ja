```
ColumnNorm
```

最大ノルムを持つ列がその後の計算に使用されます。これはピボットQR因子分解に使用されます。

行列の[要素型](@ref eltype)は、[`norm`](@ref)および[`abs`](@ref)メソッドを許容する必要があり、それぞれの結果型は[`<`](@ref)メソッドを許容する必要があります。
