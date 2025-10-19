```julia
typemax(T)
```

指定された（実際の）数値 `DataType` によって表現可能な最大値。

参照: [`floatmax`](@ref), [`typemin`](@ref), [`eps`](@ref).

# 例

```jldoctest
julia> typemax(Int8)
127

julia> typemax(UInt32)
0xffffffff

julia> typemax(Float64)
Inf

julia> typemax(Float32)
Inf32

julia> floatmax(Float32)  # 最大の有限の Float32 浮動小数点数
3.4028235f38
```
