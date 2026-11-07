```julia
replaceglobal!(module::Module, name::Symbol, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
```

グローバル変数の値を取得し、条件を満たす場合に指定した値へ設定する操作をアトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`replaceproperty!`](@ref Base.replaceproperty!)、[`setglobal!`](@ref)。
