```
eachslice(A::AbstractArray; dims, drop=true)
```

[`Slices`](@ref) オブジェクトを作成します。これは、`A` の次元 `dims` に対するスライスの配列であり、`A` の他の次元からすべてのデータを選択するビューを返します。`dims` は整数または整数のタプルのいずれかです。

`drop = true`（デフォルト）である場合、外側の `Slices` は内側の次元をドロップし、次元の順序は `dims` の順序に一致します。`drop = false` の場合、`Slices` は基になる配列と同じ次元性を持ち、内側の次元はサイズ 1 になります。

`eachslice(A; dims::Integer)` の逆については [`stack`](@ref)`(slices; dims)` を参照してください。

また、[`eachrow`](@ref)、[`eachcol`](@ref)、[`mapslices`](@ref)、および [`selectdim`](@ref) も参照してください。

!!! compat "Julia 1.1"
    この関数は少なくとも Julia 1.1 を必要とします。


!!! compat "Julia 1.9"
    Julia 1.9 より前は、これはイテレータを返し、単一の次元 `dims` のみがサポートされていました。


# 例

```jldoctest
julia> m = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> s = eachslice(m, dims=1)
3-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]

julia> s[1]
3-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2
 3

julia> eachslice(m, dims=1, drop=false)
3×1 Slices{Matrix{Int64}, Tuple{Int64, Colon}, Tuple{Base.OneTo{Int64}, Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}, 2}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]
```
