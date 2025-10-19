```julia
real(A::AbstractArray)
```

配列 `A` の各エントリの実部を含む配列を返します。

`real.(A)` と同等ですが、`eltype(A) <: Real` の場合は `A` がコピーされずに返され、`A` がゼロ次元の場合はスカラーではなく0次元の配列が返されます。

# 例

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
