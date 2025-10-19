```julia
map(f, A::AbstractArray...) -> N-array
```

同じ [`ndims`](@ref) を持つ多次元配列に作用する場合、それらはすべて同じ [`axes`](@ref) を持たなければならず、結果も同様になります。

サイズが不一致の [`broadcast`](@ref) も参照してください。

# 例

```julia
julia> map(//, [1 2; 3 4], [4 3; 2 1])
2×2 Matrix{Rational{Int64}}:
 1//4  2//3
 3//2  4//1

julia> map(+, [1 2; 3 4], zeros(2,1))
ERROR: DimensionMismatch

julia> map(+, [1 2; 3 4], [1,10,100,1000], zeros(3,1))  # 3番目が尽きるまで反復
3-element Vector{Float64}:
   2.0
  13.0
 102.0
```
