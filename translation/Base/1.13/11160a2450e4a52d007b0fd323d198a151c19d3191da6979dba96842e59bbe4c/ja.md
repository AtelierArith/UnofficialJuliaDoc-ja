```julia
fieldtypes(T::Type)
```

複合型 DataType `T` のすべてのフィールドの宣言型をタプルとして返します。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1 以降が必要です。


# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldtypes(Foo)
(Int64, String)
```
