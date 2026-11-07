```julia
nextfloat(x::AbstractFloat, n::Integer)
```

`n >= 0` の場合、`x` に `nextfloat` を `n` 回繰り返し適用した結果、または `n < 0` の場合、[`prevfloat`](@ref) を `-n` 回適用した結果。
