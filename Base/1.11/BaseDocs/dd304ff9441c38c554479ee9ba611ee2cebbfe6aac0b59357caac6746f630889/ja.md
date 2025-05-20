```
modifyglobal!(module::Module, name::Symbol, op, x, [order::Symbol=:monotonic]) -> Pair
```

関数 `op` を適用した後にグローバルを取得して設定する操作を原子的に実行します。

!!! compat "Julia 1.11"
    この関数は Julia 1.11 以降が必要です。


他に [`modifyproperty!`](@ref Base.modifyproperty!) と [`setglobal!`](@ref) を参照してください。
