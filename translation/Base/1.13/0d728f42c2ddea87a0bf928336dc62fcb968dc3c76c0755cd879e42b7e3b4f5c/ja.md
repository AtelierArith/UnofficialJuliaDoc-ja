```julia
ispublic(m::Module, s::Symbol)::Bool
```

シンボルがモジュール内でパブリックとしてマークされているかどうかを返します。

エクスポートされたシンボルはパブリックとみなされます。

!!! compat "Julia 1.11"
    この関数とパブリックという概念は、Julia 1.11で追加されました。


関連項目: [`isexported`](@ref)、[`names`](@ref)

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
