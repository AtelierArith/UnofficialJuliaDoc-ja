```julia
cumprod!(y::AbstractVector, x::AbstractVector)
```

ベクトル `x` の累積積を計算し、結果を `y` に格納します。[`cumprod`](@ref) も参照してください。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。

