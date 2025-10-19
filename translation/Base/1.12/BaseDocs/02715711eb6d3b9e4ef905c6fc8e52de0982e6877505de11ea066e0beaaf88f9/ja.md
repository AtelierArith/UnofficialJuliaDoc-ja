```julia
UndefRefError()
```

指定されたオブジェクトに対してアイテムまたはフィールドが定義されていません。

# 例

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
