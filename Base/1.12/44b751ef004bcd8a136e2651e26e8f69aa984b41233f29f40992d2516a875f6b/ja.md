```julia
typemin(T)
```

指定された（実数の）数値データ型 `T` によって表現可能な最小値。

参照: [`floatmin`](@ref), [`typemax`](@ref), [`eps`](@ref)。

# 例

```jldoctest
julia> typemin(Int8)
-128

julia> typemin(UInt32)
0x00000000

julia> typemin(Float16)
-Inf16

julia> typemin(Float32)
-Inf32

julia> nextfloat(-Inf32)  # 最小の有限 Float32 浮動小数点数
-3.4028235f38
```
