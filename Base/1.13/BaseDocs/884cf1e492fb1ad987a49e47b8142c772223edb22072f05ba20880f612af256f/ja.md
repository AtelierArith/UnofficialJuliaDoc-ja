```julia
UndefRefError()
```

指定されたオブジェクトに対して、この項目またはフィールドは定義されていません。

# Examples

```jldoctest
julia> struct MyType
           a::Vector{Int}
           MyType() = new()
       end

julia> A = MyType()
MyType(#undef)

julia> A.a
ERROR: UndefRefError: access to undefined reference
Stacktrace:
[...]
```
