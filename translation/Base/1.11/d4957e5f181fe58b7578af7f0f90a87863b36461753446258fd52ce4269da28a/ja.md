```
circcopy!(dest, src)
```

`src`を`dest`にコピーし、各次元をその長さでモジュロインデックスします。`src`と`dest`は同じサイズでなければなりませんが、インデックスにオフセットを持つことができます。オフセットがある場合、(円形の)ラップアラウンドが発生します。配列が重複するインデックスを持つ場合、重複の領域において`dest`は`src`と一致します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


参照: [`circshift`](@ref).

# 例

```julia-repl
julia> src = reshape(Vector(1:16), (4,4))
4×4 Array{Int64,2}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> dest = OffsetArray{Int}(undef, (0:3,2:5))

julia> circcopy!(dest, src)
OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}} with indices 0:3×2:5:
 8  12  16  4
 5   9  13  1
 6  10  14  2
 7  11  15  3

julia> dest[1:3,2:4] == src[1:3,2:4]
true
```
