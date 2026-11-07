```julia
nextfloat(x::AbstractFloat, n::Integer)
```

`x` に対して `nextfloat` を `n` 回反復適用した結果（`n >= 0` の場合）、または [`prevfloat`](@ref) を `-n` 回適用した結果（`n < 0` の場合）。
