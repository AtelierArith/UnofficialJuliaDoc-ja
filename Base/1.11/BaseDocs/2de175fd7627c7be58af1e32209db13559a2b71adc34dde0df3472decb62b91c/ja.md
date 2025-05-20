```
DataType <: Type{T}
```

`DataType`は、名前が付けられた明示的に宣言された型、明示的に宣言されたスーパタイプ、およびオプションでパラメータを持つ型を表します。システム内のすべての具体的な値は、何らかの`DataType`のインスタンスです。

# 例

```jldoctest
julia> typeof(Real)
DataType

julia> typeof(Int)
DataType

julia> struct Point
           x::Int
           y
       end

julia> typeof(Point)
DataType
```
