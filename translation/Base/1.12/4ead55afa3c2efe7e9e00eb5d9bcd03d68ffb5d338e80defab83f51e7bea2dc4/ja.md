```julia
fieldtype(T, name::Symbol | index::Int)
```

複合データ型 `T` におけるフィールド（名前またはインデックスで指定）の宣言された型を決定します。

# 例

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
