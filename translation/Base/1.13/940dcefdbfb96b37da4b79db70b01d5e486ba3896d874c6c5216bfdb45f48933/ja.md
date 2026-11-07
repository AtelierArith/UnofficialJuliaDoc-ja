```julia
map(f, A::AbstractArray...) -> N-array
```

同じ[`ndims`](@ref)の多次元配列に対して処理を行う場合、すべての配列の[`axes`](@ref)が同じでなければならず、結果も同じになります。

サイズが一致しない場合に使える[`broadcast`](@ref)も参照してください。

# Examples

```julia
julia> map(//, [1 2; 3 4], [4 3; 2 1])
2×2 Matrix{Rational{Int64}}:
 1//4  2//3
 3//2  4//1

julia> map(+, [1 2; 3 4], zeros(2,1))
ERROR: DimensionMismatch

julia> map(+, [1 2; 3 4], [1,10,100,1000], zeros(3,1))  # iterates until 3rd is exhausted
3-element Vector{Float64}:
   2.0
  13.0
 102.0
```
