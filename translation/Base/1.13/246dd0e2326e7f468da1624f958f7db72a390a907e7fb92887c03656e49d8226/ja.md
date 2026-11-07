```julia
reshape(A, dims...)::AbstractArray
reshape(A, dims)::AbstractArray
```

`A`と同じデータを持ち、次元のサイズまたは次元数が異なる配列を返します。2つの配列は同じ基底データを共有するため、結果が変更可能であるのは`A`が変更可能な場合に限られます。また、一方の要素を設定すると、もう一方の値も変わります。

新しい次元は、引数のリストまたは形状タプルで指定できます。`:`を使って指定できる次元は最大1つです。その場合、その次元の長さは、指定されたすべての次元との積が元の配列`A`の長さと等しくなるように計算されます。要素の総数は変わりません。

# Examples

```jldoctest
julia> A = Vector(1:16)
16-element Vector{Int64}:
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15
 16

julia> reshape(A, (4, 4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> reshape(A, 2, :)
2×8 Matrix{Int64}:
 1  3  5  7   9  11  13  15
 2  4  6  8  10  12  14  16

julia> reshape(1:6, 2, 3)
2×3 reshape(::UnitRange{Int64}, 2, 3) with eltype Int64:
 1  3  5
 2  4  6
```
