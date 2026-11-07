```julia
real(A::AbstractArray)
```

配列 `A` の各要素の実部を含む配列を返します。

`real.(A)` と同等ですが、`eltype(A) <: Real` `A` はコピーされずに返され、`A` の次元数が 0 の場合はスカラーではなく 0 次元配列が返されます。

# Examples

```jldoctest
julia> real([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 1
 0
 3

julia> real(fill(2 - im))
0-dimensional Array{Int64, 0}:
2
```
