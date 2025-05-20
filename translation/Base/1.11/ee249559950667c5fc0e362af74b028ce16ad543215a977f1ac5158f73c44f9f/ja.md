```
reshape(A, dims...) -> AbstractArray
reshape(A, dims) -> AbstractArray
```

`A`と同じデータを持つ配列を返しますが、異なる次元サイズまたは次元数を持ちます。2つの配列は同じ基礎データを共有しているため、結果は`A`が可変である場合にのみ可変であり、一方の要素を設定すると他方の値が変更されます。

新しい次元は、引数のリストまたは形状のタプルとして指定できます。最大1つの次元は`:`で指定でき、その場合、その長さは指定されたすべての次元との積が元の配列`A`の長さに等しくなるように計算されます。要素の総数は変更されてはいけません。

# 例

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
