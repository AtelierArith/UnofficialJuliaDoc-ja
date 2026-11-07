```julia
swapfield!(value, name::Symbol, x, [order::Symbol])
swapfield!(value, i::Int, x, [order::Symbol])
```

フィールドの取得と設定を同時に行う操作をアトミックに実行します。

```julia
y = getfield(value, name)
setfield!(value, name, x)
return y
```

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。

