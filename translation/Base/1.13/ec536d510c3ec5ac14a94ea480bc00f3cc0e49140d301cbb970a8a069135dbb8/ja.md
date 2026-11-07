```julia
hasfield(T::Type, name::Symbol)
```

`T` が `name` を自身のフィールドの1つとして持つかどうかを示すブール値を返します。

関連項目: [`fieldnames`](@ref)、[`fieldcount`](@ref)、[`hasproperty`](@ref)。

!!! compat "Julia 1.2"
    この関数を使用するには、Julia 1.2 以降が必要です。


# Examples

```jldoctest
julia> struct Foo
            bar::Int
       end

julia> hasfield(Foo, :bar)
true

julia> hasfield(Foo, :x)
false
```
