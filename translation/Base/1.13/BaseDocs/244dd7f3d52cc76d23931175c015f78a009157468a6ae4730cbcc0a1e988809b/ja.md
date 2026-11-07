```julia
declare_global(module::Module, name::Symbol, strong::Bool=false, [ty::Type])
```

モジュール `module` 内でグローバル `name` を宣言します。`ty` が指定されている場合は、定数束縛に置き換えられない「強い」グローバルを宣言します。指定されていない場合は、弱いグローバルを宣言します。

関連項目: [`global`](@ref)、[`setglobal!`](@ref)、[`get_binding_type`](@ref Core.get_binding_type)。
