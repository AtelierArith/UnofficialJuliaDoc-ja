```
circshift(A, shifts)
```

配列内のデータを円環的にシフト（回転）します。第二引数は、各次元でのシフト量を指定するタプルまたはベクトル、または最初の次元のみをシフトする整数です。

関連: [`circshift!`](@ref), [`circcopy!`](@ref), [`bitrotate`](@ref), [`<<`](@ref).

# 例

```jldoctest
julia> b = reshape(Vector(1:16), (4,4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> circshift(b, (0,2))
4×4 Matrix{Int64}:
  9  13  1  5
 10  14  2  6
 11  15  3  7
 12  16  4  8

julia> circshift(b, (-1,0))
4×4 Matrix{Int64}:
 2  6  10  14
 3  7  11  15
 4  8  12  16
 1  5   9  13

julia> a = BitArray([true, true, false, false, true])
5-element BitVector:
 1
 1
 0
 0
 1

julia> circshift(a, 1)
5-element BitVector:
 1
 1
 1
 0
 0

julia> circshift(a, -1)
5-element BitVector:
 1
 0
 0
 1
 1
```
