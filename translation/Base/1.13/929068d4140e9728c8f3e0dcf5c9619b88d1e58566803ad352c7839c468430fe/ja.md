```julia
float(T::Type)
```

`T`型の値を浮動小数点値として表すのに適した型を返します。`typeof(float(zero(T)))`と同等です。

# Examples

```jldoctest
julia> float(Complex{Int})
ComplexF64 (alias for Complex{Float64})

julia> float(Int)
Float64
```
