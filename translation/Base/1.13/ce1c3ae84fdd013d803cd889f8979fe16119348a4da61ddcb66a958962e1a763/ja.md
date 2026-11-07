```julia
repeat(A::AbstractArray; inner=ntuple(Returns(1), ndims(A)), outer=ntuple(Returns(1), ndims(A)))
```

`A`の各要素を繰り返して配列を構築します。`inner`のi番目の要素は、`A`のi番目の次元にある各要素を繰り返す回数を指定します。`outer`のi番目の要素は、`A`のi番目の次元に沿ったスライスを繰り返す回数を指定します。`inner`または`outer`を省略した場合、繰り返しは行われません。

# Examples

```jldoctest
julia> repeat(1:2, inner=2)
4-element Vector{Int64}:
 1
 1
 2
 2

julia> repeat(1:2, outer=2)
4-element Vector{Int64}:
 1
 2
 1
 2

julia> repeat([1 2; 3 4], inner=(2, 1), outer=(1, 3))
4×6 Matrix{Int64}:
 1  2  1  2  1  2
 1  2  1  2  1  2
 3  4  3  4  3  4
 3  4  3  4  3  4
```
