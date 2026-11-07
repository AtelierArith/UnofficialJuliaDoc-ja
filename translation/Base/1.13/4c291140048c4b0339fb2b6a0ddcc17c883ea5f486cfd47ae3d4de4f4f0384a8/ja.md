```julia
reim(A::AbstractArray)
```

`A` の各要素について、実部と虚部をそれぞれ含む2つの配列をタプルで返します。

`(real.(A), imag.(A))` と同等ですが、`eltype(A) <: Real` の場合は、実部を表すためにコピーせず `A` を返します。また、`A` の次元数が0の場合は、スカラーではなく0次元配列を返します。

# Examples

```jldoctest
julia> reim([1, 2im, 3 + 4im])
([1, 0, 3], [0, 2, 4])

julia> reim(fill(2 - im))
(fill(2), fill(-1))
```
