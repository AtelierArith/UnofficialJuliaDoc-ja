```julia
cumprod!(y::AbstractVector, x::AbstractVector)
```

ベクトル `x` の累積積を計算し、その結果を `y` に格納します。詳細は [`cumprod`](@ref) を参照してください。

!!! warning
    いずれかの変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。

