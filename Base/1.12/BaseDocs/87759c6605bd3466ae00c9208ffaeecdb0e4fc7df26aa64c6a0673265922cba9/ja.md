```julia
modifyglobal!(module::Module, name::Symbol, op, x, [order::Symbol=:monotonic]) -> Pair
```

アトミックに操作を実行して、関数 `op` を適用した後にグローバルを取得して設定します。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。


他に [`modifyproperty!`](@ref Base.modifyproperty!) と [`setglobal!`](@ref) を参照してください。
