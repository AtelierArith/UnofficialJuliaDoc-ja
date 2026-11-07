```julia
real(T::Type)
```

型 `T` の値の実部を表す型を返します。たとえば、`T == Complex{R}` の場合は `R` を返します。`typeof(real(zero(T)))` と同等です。

# Examples

```jldoctest
julia> real(Complex{Int})
Int64

julia> real(Float64)
Float64
```
