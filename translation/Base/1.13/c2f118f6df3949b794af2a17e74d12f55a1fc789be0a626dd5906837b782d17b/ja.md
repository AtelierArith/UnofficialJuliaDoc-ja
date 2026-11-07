```julia
typemax(T)
```

指定された（実数）数値型で表現できる最大値 `DataType`。

関連項目: [`floatmax`](@ref), [`maxintfloat`](@ref), [`typemin`](@ref), [`eps`](@ref)。

# Examples

```jldoctest
julia> typemax(Int8)
127

julia> typemax(UInt32)
0xffffffff

julia> typemax(Float64)
Inf

julia> typemax(Float32)
Inf32

julia> floatmax(Float32)  # largest positive finite Float32 floating point number
3.4028235f38
```
