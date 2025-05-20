```
lastindex(collection) -> Integer
lastindex(collection, d) -> Integer
```

`collection`の最後のインデックスを返します。`d`が指定されている場合、次元`d`に沿った`collection`の最後のインデックスを返します。

構文`A[end]`および`A[end, end]`はそれぞれ`A[lastindex(A)]`および`A[lastindex(A, 1), lastindex(A, 2)]`に変換されます。

参照: [`axes`](@ref), [`firstindex`](@ref), [`eachindex`](@ref), [`prevind`](@ref)。

# 例

```jldoctest
julia> lastindex([1,2,4])
3

julia> lastindex(rand(3,4,5), 2)
4
```
