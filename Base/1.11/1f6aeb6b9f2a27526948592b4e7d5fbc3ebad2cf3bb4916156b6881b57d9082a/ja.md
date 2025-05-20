```
firstindex(collection) -> 整数
firstindex(collection, d) -> 整数
```

`collection`の最初のインデックスを返します。`d`が指定されている場合、次元`d`に沿った`collection`の最初のインデックスを返します。

構文`A[begin]`および`A[1, begin]`はそれぞれ`A[firstindex(A)]`および`A[1, firstindex(A, 2)]`に変換されます。

参照: [`first`](@ref), [`axes`](@ref), [`lastindex`](@ref), [`nextind`](@ref).

# 例

```jldoctest
julia> firstindex([1,2,4])
1

julia> firstindex(rand(3,4,5), 2)
1
```
