```julia
float(T::Type)
```

値の型 `T` を浮動小数点値として表現するための適切な型を返します。`typeof(float(zero(T)))` と同等です。

# 例

```jldoctest
julia> float(Complex{Int})
ComplexF64 (alias for Complex{Float64})

julia> float(Int)
Float64
```
