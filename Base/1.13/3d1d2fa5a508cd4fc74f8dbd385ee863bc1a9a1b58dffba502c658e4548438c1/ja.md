```julia
BitArray(undef, dims::Integer...)
BitArray{N}(undef, dims::NTuple{N,Int})
```

指定された次元で未定義の[`BitArray`](@ref)を構築します。[`Array`](@ref)コンストラクターと同じように動作します。[`undef`](@ref)を参照してください。

# Examples

```jldoctest; filter = r"[01]"
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
