```julia
isdefinedglobal(m::Module, s::Symbol, [allow_import::Bool=true, [order::Symbol=:unordered]])
```

モジュール `m` 内で（現在のワールドエイジにおいて）グローバル変数 `s` が定義されているかどうかを判定します。グローバル変数から値を読み取ることができ、そのアクセスで例外がスローされない場合に限り、その変数は定義されているとみなされます。これには、定数と、値が設定されているグローバル変数の両方が含まれます。

`allow_import` が `false` の場合、グローバル変数は `m` 内で定義されている必要があり、別のモジュールからインポートすることはできません。

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
