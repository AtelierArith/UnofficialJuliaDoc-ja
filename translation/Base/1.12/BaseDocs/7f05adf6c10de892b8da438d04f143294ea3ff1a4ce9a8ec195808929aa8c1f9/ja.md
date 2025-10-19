```julia
modifyfield!(value, name::Symbol, op, x, [order::Symbol]) -> Pair
modifyfield!(value, i::Int, op, x, [order::Symbol]) -> Pair
```

関数 `op` を適用した後にフィールドを取得および設定する操作を原子的に実行します。

```julia
y = getfield(value, name)
z = op(y, x)
setfield!(value, name, z)
return y => z
```

ハードウェアがサポートしている場合（例えば、原子的なインクリメント）、これは適切なハードウェア命令に最適化される可能性があります。そうでない場合は、ループを使用します。

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降が必要です。

