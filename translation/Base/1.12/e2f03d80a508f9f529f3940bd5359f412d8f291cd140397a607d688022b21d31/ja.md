```julia
fieldtypes(T::Type)
```

複合データ型 `T` のすべてのフィールドの宣言された型をタプルとして返します。

!!! compat "Julia 1.1"
    この関数は少なくとも Julia 1.1 を必要とします。


# 例

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldtypes(Foo)
(Int64, String)
```
