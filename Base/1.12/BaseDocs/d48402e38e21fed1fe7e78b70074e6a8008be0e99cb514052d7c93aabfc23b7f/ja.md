```julia
isdefinedglobal(m::Module, s::Symbol, [allow_import::Bool=true, [order::Symbol=:unordered]])
```

モジュール `m` においてグローバル変数 `s` が定義されているかどうかをテストします（現在のワールドエイジにおいて）。変数は、グローバル変数から値を読み取ることができ、アクセスが例外をスローしない場合にのみ定義されていると見なされます。これには、定数と値が設定されているグローバル変数の両方が含まれます。

`allow_import` が `false` の場合、グローバル変数は `m` 内で定義されている必要があり、他のモジュールからインポートされてはなりません。

!!! compat "Julia 1.12"
    この関数は Julia 1.12 以降が必要です。


関連情報として [`@isdefined`](@ref) を参照してください。

# 例

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
