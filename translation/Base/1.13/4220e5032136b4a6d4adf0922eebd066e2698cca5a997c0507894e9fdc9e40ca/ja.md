```julia
isbindingresolved(m::Module, s::Symbol) -> Bool
```

モジュール内のシンボルの束縛が解決済みかどうかを返します。

関連項目: [`isexported`](@ref)、[`ispublic`](@ref)、[`isdeprecated`](@ref)

```jldoctest
julia> module Mod
           foo() = 17
       end
Mod

julia> Base.isbindingresolved(Mod, :foo)
true
```

!!! warning
    この関数は非推奨です。束縛の「解決済み」という概念は Julia 1.12 で廃止されました。この関数は現在、常に `true` を返します。

