```
conj(A::AbstractArray)
```

配列 `A` の各エントリの複素共役を含む配列を返します。

`conj.(A)` と同等ですが、`eltype(A) <: Real` の場合は `A` がコピーされずに返され、`A` がゼロ次元の場合はスカラーではなく0次元の配列が返されます。

# 例

```jldoctest
julia> conj([1, 2im, 3 + 4im])
3-element Vector{Complex{Int64}}:
 1 + 0im
 0 - 2im
 3 - 4im

julia> conj(fill(2 - im))
0-dimensional Array{Complex{Int64}, 0}:
2 + 1im
```
