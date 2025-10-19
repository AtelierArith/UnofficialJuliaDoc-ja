```julia
hasfield(T::Type, name::Symbol)
```

`T`が`name`を自身のフィールドの1つとして持っているかどうかを示すブール値を返します。

関連情報としては[`fieldnames`](@ref)、[`fieldcount`](@ref)、[`hasproperty`](@ref)があります。

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
