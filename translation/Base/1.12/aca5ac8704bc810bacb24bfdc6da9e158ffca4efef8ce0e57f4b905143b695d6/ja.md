```julia
ispublic(m::Module, s::Symbol) -> Bool
```

モジュール内でシンボルが公開されているかどうかを返します。

エクスポートされたシンボルは公開と見なされます。

!!! compat "Julia 1.11"
    この関数と公開性の概念はJulia 1.11で追加されました。


関連情報: [`isexported`](@ref), [`names`](@ref)

```jldoctest
julia> module Mod
           export foo
           public bar
       end
Mod

julia> Base.ispublic(Mod, :foo)
true

julia> Base.ispublic(Mod, :bar)
true

julia> Base.ispublic(Mod, :baz)
false
```
