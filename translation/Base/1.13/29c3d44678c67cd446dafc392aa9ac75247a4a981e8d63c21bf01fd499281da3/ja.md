```julia
typemin(T)
```

指定された（実数の）数値型 DataType で表現できる最小の値 `T`。

関連項目: [`floatmin`](@ref)、[`maxintfloat`](@ref)、[`typemax`](@ref)、[`eps`](@ref)。

# Examples

```jldoctest
julia> typemin(Int8)
-128

julia> typemin(UInt32)
0x00000000

julia> typemin(Float16)
-Inf16

julia> typemin(Float32)
-Inf32

julia> floatmin(Float32)  # smallest positive finite Float32 floating point number
1.1754944f-38

julia> nextfloat(-Inf32) == -floatmax(Float32)  # equivalent ways of getting the lowest finite Float32 floating point number
true
```
