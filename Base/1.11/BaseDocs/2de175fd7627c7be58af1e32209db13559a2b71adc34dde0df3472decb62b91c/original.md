```
DataType <: Type{T}
```

`DataType` represents explicitly declared types that have names, explicitly declared supertypes, and, optionally, parameters.  Every concrete value in the system is an instance of some `DataType`.

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
