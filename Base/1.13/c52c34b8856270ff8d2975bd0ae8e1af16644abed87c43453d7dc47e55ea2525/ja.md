```julia
imag(A::AbstractArray)
```

配列 `A` の各要素の虚部を含む配列を返します。

`imag.(A)` と同等ですが、`A` の次元数が 0 の場合は、スカラーではなく 0 次元配列を返します。

# Examples

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
