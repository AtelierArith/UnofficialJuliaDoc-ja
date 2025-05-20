```
size(A::AbstractArray, [dim])
```

`A`の次元を含むタプルを返します。オプションで、特定の次元を指定してその次元の長さを取得することもできます。

`size`は非標準インデックスを持つ配列に対して定義されていない場合があるため、その場合は[`axes`](@ref)が役立つかもしれません。カスタムインデックスを持つ配列に関するマニュアルの章を参照してください。[arrays with custom indices](@ref man-custom-indices)。

関連情報: [`length`](@ref), [`ndims`](@ref), [`eachindex`](@ref), [`sizeof`](@ref)。

# 例

```jldoctest
julia> A = fill(1, (2,3,4));

julia> size(A)
(2, 3, 4)

julia> size(A, 2)
3
```
