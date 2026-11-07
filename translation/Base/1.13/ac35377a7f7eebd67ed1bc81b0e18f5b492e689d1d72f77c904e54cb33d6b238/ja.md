```julia
circshift(A, shifts)
```

`A`内のデータを循環シフト（回転）します。第2引数には、各次元でのシフト量を指定するタプルまたはベクトルを渡します。整数を渡した場合は、第1次元のみをシフトします。

シフト量がコンパイル時に既知、つまりコンパイル時定数である場合、生成されるコードは最も効率的になります。

関連項目: [`circshift!`](@ref)、[`circcopy!`](@ref)、[`bitrotate`](@ref)、[`<<`](@ref)。

# Examples

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

julia> x = (1, 2, 3, 4, 5)
(1, 2, 3, 4, 5)

julia> circshift(x, 4)
(2, 3, 4, 5, 1)

julia> z = (1, 'a', -7.0, 3)
(1, 'a', -7.0, 3)

julia> circshift(z, -1)
('a', -7.0, 3, 1)
```
