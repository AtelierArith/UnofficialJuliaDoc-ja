```julia
isassigned(array, i)::Bool
```

指定された配列に、インデックス `i` に対応する値があるかどうかを判定します。インデックスが範囲外の場合、または未定義の参照がある場合は、`false` を返します。

# Examples

```jldoctest
julia> isassigned(rand(3, 3), 5)
true

julia> isassigned(rand(3, 3), 3 * 3 + 1)
false

julia> mutable struct Foo end

julia> v = similar(rand(3), Foo)
3-element Vector{Foo}:
 #undef
 #undef
 #undef

julia> isassigned(v, 1)
false
```
