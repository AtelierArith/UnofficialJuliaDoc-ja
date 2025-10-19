```julia
nextfloat(x::AbstractFloat, n::Integer)
```

`n` が 0 以上の場合は `x` に `nextfloat` を `n` 回適用した結果、`n` が 0 未満の場合は [`prevfloat`](@ref) を `-n` 回適用した結果。
