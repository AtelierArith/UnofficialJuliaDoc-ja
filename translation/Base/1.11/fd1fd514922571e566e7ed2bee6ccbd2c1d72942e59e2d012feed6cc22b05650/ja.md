```
typemax(T)
```

指定された（実数の）数値 `DataType` が表現できる最大値。

関連情報: [`floatmax`](@ref), [`typemin`](@ref), [`eps`](@ref)。

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

julia> floatmax(Float32)  # 最大の有限 Float32 浮動小数点数
3.4028235f38
```
