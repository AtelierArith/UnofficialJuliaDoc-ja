```
float(T::Type)
```

型 `T` の値を浮動小数点値として表すための適切な型を返します。`typeof(float(zero(T)))` と同等です。

# 例

```jldoctest
julia> float(Complex{Int})
ComplexF64 (alias for Complex{Float64})

julia> float(Int)
Float64
```
