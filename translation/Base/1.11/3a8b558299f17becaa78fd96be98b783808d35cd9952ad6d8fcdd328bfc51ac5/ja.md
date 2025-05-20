```
repeat(A::AbstractArray; inner=ntuple(Returns(1), ndims(A)), outer=ntuple(Returns(1), ndims(A)))
```

配列 `A` のエントリを繰り返すことによって配列を構築します。`inner` の i 番目の要素は、`A` の i 番目の次元の個々のエントリを繰り返す回数を指定します。`outer` の i 番目の要素は、`A` の i 番目の次元に沿ったスライスを繰り返す回数を指定します。`inner` または `outer` が省略された場合、繰り返しは行われません。

# 例

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
