```julia
DataType <: Type{T}
```

`DataType`は、名前と明示的に宣言されたスーパータイプを持ち、必要に応じてパラメーターも持つ、明示的に宣言された型を表します。システム内のすべての具体的な値は、いずれかの`DataType`のインスタンスです。

# Examples

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
