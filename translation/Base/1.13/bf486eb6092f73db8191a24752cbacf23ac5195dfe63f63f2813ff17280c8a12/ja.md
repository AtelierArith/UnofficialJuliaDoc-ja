```julia
size(A::AbstractArray, [dim])
```

`A`の次元をタプルで返します。特定の次元の長さだけを取得することもできます。

標準的でないインデックスを持つ配列では、`size`が定義されていない場合があります。その場合は[`axes`](@ref)が役立ちます。詳しくは、マニュアルの[arrays with custom indices](@ref man-custom-indices)の章を参照してください。

関連項目: [`length`](@ref)、[`ndims`](@ref)、[`eachindex`](@ref)、[`sizeof`](@ref)。

# Examples

```jldoctest
julia> A = fill(1, (2,3,4));

julia> size(A)
(2, 3, 4)

julia> size(A, 2)
3
```
