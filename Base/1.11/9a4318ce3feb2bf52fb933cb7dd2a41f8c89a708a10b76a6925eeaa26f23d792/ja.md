```
real(T::Type)
```

型 `T` の値の実部を表す型を返します。例えば、`T == Complex{R}` の場合、`R` を返します。`typeof(real(zero(T)))` と同等です。

# 例

```jldoctest
julia> real(Complex{Int})
Int64

julia> real(Float64)
Float64
```
