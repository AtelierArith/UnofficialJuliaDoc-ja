```
fieldtypes(T::Type)
```

The declared types of all fields in a composite DataType `T` as a tuple.

!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.


# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldtypes(Foo)
(Int64, String)
```
