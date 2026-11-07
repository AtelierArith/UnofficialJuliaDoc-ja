```julia
isdefinedglobal(m::Module, s::Symbol, [allow_import::Bool=true, [order::Symbol=:unordered]])
```

モジュール `m`（現在のワールドエイジ）で、グローバル変数 `s` が定義されているかどうかを判定します。グローバル変数が定義されているとみなされるのは、その変数から値を読み取ることができ、アクセスしても例外が発生しない場合に限ります。これには、定数と、値が設定されたグローバル変数の両方が含まれます。

`allow_import` が `false` の場合、グローバル変数は `m` 内で定義されている必要があり、別のモジュールからインポートされたものであってはなりません。

!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。


関連項目: [`@isdefined`](@ref)。

# Examples

```jldoctest
julia> isdefinedglobal(Base, :sum)
true

julia> isdefinedglobal(Base, :NonExistentMethod)
false

julia> isdefinedglobal(Base, :sum, false)
true

julia> isdefinedglobal(Main, :sum, false)
false
```
