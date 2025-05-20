```
imag(A::AbstractArray)
```

配列 `A` の各エントリの虚部を含む配列を返します。

`imag.(A)` と同等ですが、`A` がゼロ次元の場合はスカラーではなく、0次元の配列が返されます。

# 例

```jldoctest
julia> imag([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 0
 2
 4

julia> imag(fill(2 - im))
0-dimensional Array{Int64, 0}:
-1
```
