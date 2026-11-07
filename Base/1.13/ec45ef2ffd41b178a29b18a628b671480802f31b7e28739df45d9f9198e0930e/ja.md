```julia
fieldtype(T, name::Symbol | index::Int)
```

複合 DataType `T` のフィールド（名前またはインデックスで指定）の宣言型を取得します。

# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldtype(Foo, :x)
Int64

julia> fieldtype(Foo, 2)
String
```
