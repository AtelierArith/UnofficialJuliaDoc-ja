```julia
sizeof(T::DataType)
sizeof(obj)
```

指定された `DataType` `T` の正規バイナリ表現がある場合、そのサイズ（バイト単位）。`DataType` でない場合は、オブジェクト `obj` のサイズ（バイト単位）。

関連項目: [`Base.summarysize`](@ref)。

# Examples

```jldoctest
julia> sizeof(Float32)
4

julia> sizeof(ComplexF64)
16

julia> sizeof(1.0)
8

julia> sizeof(collect(1.0:10.0))
80

julia> struct StructWithPadding
           x::Int64
           flag::Bool
       end

julia> sizeof(StructWithPadding) # not the sum of `sizeof` of fields due to padding
16

julia> sizeof(Int64) + sizeof(Bool) # different from above
9
```

`DataType` `T` に特定のサイズがない場合、エラーがスローされます。

```jldoctest
julia> sizeof(AbstractArray)
ERROR: Abstract type AbstractArray does not have a definite size.
Stacktrace:
[...]
```
