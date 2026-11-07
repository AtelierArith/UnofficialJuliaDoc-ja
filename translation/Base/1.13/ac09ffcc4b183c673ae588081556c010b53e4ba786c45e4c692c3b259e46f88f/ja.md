```julia
cumprod(A; dims::Integer)
```

次元 `dim` に沿った累積積。パフォーマンスの向上や、出力の精度の制御（オーバーフローの回避など）のために、事前に確保した出力配列を使う方法については [`cumprod!`](@ref) も参照してください。

# Examples

```jldoctest
julia> a = Int8[1 2 3; 4 5 6];

julia> cumprod(a, dims=1)
2×3 Matrix{Int64}:
 1   2   3
 4  10  18

julia> cumprod(a, dims=2)
2×3 Matrix{Int64}:
 1   2    6
 4  20  120
```
