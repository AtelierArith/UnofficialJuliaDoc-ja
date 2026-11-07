```julia
setglobalonce!(module::Module, name::Symbol, value,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

グローバル変数がまだ設定されていない場合に限り、指定した値を設定する操作をアトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`setpropertyonce!`](@ref Base.setpropertyonce!)、[`setglobal!`](@ref)。
