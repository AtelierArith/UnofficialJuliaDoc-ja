```julia
BitArray(undef, dims::Integer...)
BitArray{N}(undef, dims::NTuple{N,Int})
```

与えられた次元を持つ未定義の [`BitArray`](@ref) を構築します。 [`Array`](@ref) コンストラクタと同様に動作します。 [`undef`](@ref) を参照してください。

# 例

```julia-repl
julia> BitArray(undef, 2, 2)
2×2 BitMatrix:
 0  0
 0  0

julia> BitArray(undef, (3, 1))
3×1 BitMatrix:
 0
 0
 0
```
