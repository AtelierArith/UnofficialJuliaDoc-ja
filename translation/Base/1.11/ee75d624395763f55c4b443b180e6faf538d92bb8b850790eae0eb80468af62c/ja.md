```
hasfield(T::Type, name::Symbol)
```

`T`が自分のフィールドの1つとして`name`を持っているかどうかを示すブール値を返します。

[`fieldnames`](@ref)、[`fieldcount`](@ref)、[`hasproperty`](@ref)も参照してください。

!!! compat "Julia 1.2"
    この関数は少なくともJulia 1.2が必要です。


# 例

```jldoctest
julia> struct Foo
            bar::Int
       end

julia> hasfield(Foo, :bar)
true

julia> hasfield(Foo, :x)
false
```
