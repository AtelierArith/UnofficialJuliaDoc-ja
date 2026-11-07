```julia
last(coll)
```

O(1) 時間で計算できる場合、順序付きコレクションの最後の要素を取得します。これは、最後のインデックスを取得するために [`lastindex`](@ref) を呼び出すことで実現します。空の場合でも、[`AbstractRange`](@ref) の終点を返します。

関連項目: [`first`](@ref)、[`endswith`](@ref)。

# Examples

```jldoctest
julia> last(1:2:10)
9

julia> last([1; 2; 3; 4])
4
```
