```julia
prevfloat(x::AbstractFloat, n::Integer)
```

`x` に対して `prevfloat` を `n` 回反復適用した結果（`n >= 0` の場合）、または [`nextfloat`](@ref) を `-n` 回適用した結果（`n < 0` の場合）。
