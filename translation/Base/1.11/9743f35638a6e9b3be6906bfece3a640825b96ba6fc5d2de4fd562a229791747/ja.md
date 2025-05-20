```
prevfloat(x::AbstractFloat, n::Integer)
```

`n` 回の `prevfloat` を `x` に適用した結果（`n >= 0` の場合）、または `-n` 回の [`nextfloat`](@ref) の適用結果（`n < 0` の場合）。
