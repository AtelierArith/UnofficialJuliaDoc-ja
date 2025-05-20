```
isexported(m::Module, s::Symbol) -> Bool
```

モジュールからシンボルがエクスポートされているかどうかを返します。

関連情報: [`ispublic`](@ref), [`names`](@ref)

```jldoctest
julia> module Mod
           export foo
           public bar
       end
Mod

julia> Base.isexported(Mod, :foo)
true

julia> Base.isexported(Mod, :bar)
false

julia> Base.isexported(Mod, :baz)
false
```
