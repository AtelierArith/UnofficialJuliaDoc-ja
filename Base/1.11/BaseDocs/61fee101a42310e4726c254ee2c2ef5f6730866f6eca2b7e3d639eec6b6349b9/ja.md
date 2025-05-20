```
swapfield!(value, name::Symbol, x, [order::Symbol])
swapfield!(value, i::Int, x, [order::Symbol])
```

フィールドを同時に取得して設定する操作を原子的に実行します：

```
y = getfield(value, name)
setfield!(value, name, x)
return y
```

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降が必要です。

