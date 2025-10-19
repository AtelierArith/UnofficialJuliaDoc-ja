```julia
keys(a::AbstractArray)
```

`a`の形状に配置されたすべての有効なインデックスを記述する効率的な配列を返します。

1次元配列（ベクトル）のキーは整数ですが、他のすべてのN次元配列は[`CartesianIndex`](@ref)を使用してその位置を記述します。特に、特別な配列タイプ[`LinearIndices`](@ref)と[`CartesianIndices`](@ref)は、それぞれこれらの整数と`CartesianIndex`の配列を効率的に表現するために使用されます。

配列の`keys`が最も効率的なインデックスタイプでない場合があることに注意してください。最大のパフォーマンスを得るには、代わりに[`eachindex`](@ref)を使用してください。

# 例

```jldoctest
julia> keys([4, 5, 6])
3-element LinearIndices{1, Tuple{Base.OneTo{Int64}}}:
 1
 2
 3

julia> keys([4 5; 6 7])
CartesianIndices((2, 2))
```
