```julia
firstindex(collection)::Integer
firstindex(collection, d)::Integer
```

`collection` の最初のインデックスを返します。`d` が指定されている場合は、次元 `d` に沿った `collection` の最初のインデックスを返します。

構文 `A[begin]` と `A[1, begin]` は、それぞれ `A[firstindex(A)]` と `A[1, firstindex(A, 2)]` に変換されます。

関連項目: [`first`](@ref)、[`axes`](@ref)、[`lastindex`](@ref)、[`nextind`](@ref)。

# Examples

```jldoctest
julia> firstindex([1,2,4])
1

julia> firstindex(rand(3,4,5), 2)
1
```
