```julia
eachslice(A::AbstractArray; dims, drop=true)
```

スライスされたオブジェクトを作成します。通常は[`Slices`](@ref)で、`A`の次元`dims`に沿ったスライスの配列です。各スライスは、`A`における他の次元のデータをすべて選択するビューを返します。`dims`には、整数または整数のタプルを指定できます。

`drop = true`（デフォルト）の場合、外側のスライスでは内側の次元が削除され、次元の順序は`dims`の順序と一致します。`drop = false`の場合、スライスオブジェクトの次元数は元の配列と同じになり、内側の次元のサイズは1になります。

`eachslice(A; dims::Integer)`の逆の操作については、[`stack`](@ref)`(slices; dims)`を参照してください。

[`eachrow`](@ref)、[`eachcol`](@ref)、[`mapslices`](@ref)、[`selectdim`](@ref)も参照してください。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9より前のバージョンでは、これはイテレータを返し、単一の次元`dims`のみがサポートされていました。


# Examples

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
