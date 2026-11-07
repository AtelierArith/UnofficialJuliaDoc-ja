```julia
cumprod!(B, A; dims::Integer)
```

`A`の累積積を次元`dims`に沿って計算し、結果を`B`に格納します。[`cumprod`](@ref)も参照してください。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。

