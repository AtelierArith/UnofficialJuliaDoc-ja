```julia
circcopy!(dest, src)
```

`src` を `dest` にコピーします。各次元のインデックスは、その次元の長さを法として扱われます。`src` と `dest` は同じサイズである必要がありますが、インデックスのオフセットは異なっていてもかまいません。オフセットがある場合、インデックスは循環的に折り返されます。配列のインデックスが重複する場合、重複部分の範囲では `dest` と `src` は一致します。

!!! warning
    変更対象の引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


関連項目: [`circshift`](@ref)。

# Examples

```julia-repl
julia> src = reshape(Vector(1:16), (4,4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> dest = OffsetArray{Int}(undef, (0:3,2:5));

julia> circcopy!(dest, src)
4×4 OffsetArray(::Matrix{Int64}, 0:3, 2:5) with eltype Int64 with indices 0:3×2:5:
 8  12  16  4
 5   9  13  1
 6  10  14  2
 7  11  15  3

julia> dest[1:3,2:4] == src[1:3,2:4]
true
```
