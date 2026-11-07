```julia
ispublic(m::Module, s::Symbol)::Bool
```

シンボルがモジュール内で public としてマークされているかどうかを返します。

エクスポートされたシンボルは public とみなされます。

!!! compat "Julia 1.11"
    この関数と public という概念は、Julia 1.11 で追加されました。


関連項目: [`isexported`](@ref), [`names`](@ref)

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
