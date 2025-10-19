```julia
findnext(predicate::Function, A, i)
```

`predicate`が`true`を返す`A`の要素の`i`以降の次のインデックスを見つけるか、見つからなければ`nothing`を返します。これは、[`getindex`](@ref)、[`keys(A)`](@ref)、および[`nextind`](@ref)をサポートする配列、文字列、およびほとんどの他のコレクションで機能します。

インデックスは、[`keys(A)`](@ref)および[`pairs(A)`](@ref)によって返されるものと同じ型です。

# 例

```jldoctest
julia> A = [1, 4, 2, 2];

julia> findnext(isodd, A, 1)
1

julia> findnext(isodd, A, 2) # nothingを返しますが、REPLには表示されません

julia> A = [1 4; 2 2];

julia> findnext(isodd, A, CartesianIndex(1, 1))
CartesianIndex(1, 1)

julia> findnext(isspace, "a b c", 3)
4
```
