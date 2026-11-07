```julia
Base.isbitsunion(::Type{T})
```

型が「is-bits」Union型かどうかを返します。これは、Unionに含まれる各型が[`isbitstype`](@ref)であることを意味します。

# Examples

```jldoctest
julia> Base.isbitsunion(Union{Float64, UInt8})
true

julia> Base.isbitsunion(Union{Float64, String})
false
```
