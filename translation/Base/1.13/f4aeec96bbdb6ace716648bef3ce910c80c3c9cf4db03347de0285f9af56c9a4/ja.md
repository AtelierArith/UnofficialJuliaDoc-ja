```julia
first(coll)
```

反復可能なコレクションの最初の要素を取得します。[`AbstractRange`](@ref)が空の場合でも、その開始点を返します。

関連項目: [`only`](@ref)、[`firstindex`](@ref)、[`last`](@ref)。

# Examples

```jldoctest
julia> first(2:2:10)
2

julia> first([1; 2; 3; 4])
1
```
