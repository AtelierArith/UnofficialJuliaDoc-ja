```julia
reim(A::AbstractArray)
```

`A`の各エントリの実部と虚部をそれぞれ含む2つの配列のタプルを返します。

`(real.(A), imag.(A))`と同等ですが、`eltype(A) <: Real`の場合は、実部を表すために`A`がコピーされずに返され、`A`がゼロ次元の場合はスカラーではなく0次元の配列が返されます。

# 例

```jldoctest
julia> reim([1, 2im, 3 + 4im])
([1, 0, 3], [0, 2, 4])

julia> reim(fill(2 - im))
(fill(2), fill(-1))
```
