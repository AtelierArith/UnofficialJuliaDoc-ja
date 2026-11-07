```julia
modifyfield!(value, name::Symbol, op, x, [order::Symbol])::Pair
modifyfield!(value, i::Int, op, x, [order::Symbol])::Pair
```

関数 `op` を適用した後、フィールドの取得と設定をアトミックに実行します。

```julia
y = getfield(value, name)
z = op(y, x)
setfield!(value, name, z)
return y => z
```

ハードウェアが対応している場合（アトミックなインクリメントなど）は、適切なハードウェア命令に最適化されます。対応していない場合は、ループを使用します。

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。

