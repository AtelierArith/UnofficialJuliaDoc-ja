```julia
unique!(A::AbstractVector)
```

[`isequal`](@ref) と [`hash`](@ref) によって判定される重複項目を削除し、変更後の `A` を返します。`unique!` は、`A` の要素を出現順に返します。返されるデータの順序を気にしない場合は、`A` の要素をソートできることを条件に、`(sort!(A); unique!(A))` を呼び出すほうがはるかに効率的です。

# Examples

```jldoctest
julia> unique!([1, 1, 1])
1-element Vector{Int64}:
 1

julia> A = [7, 3, 2, 3, 7, 5];

julia> unique!(A)
4-element Vector{Int64}:
 7
 3
 2
 5

julia> B = [7, 6, 42, 6, 7, 42];

julia> sort!(B);  # unique! is able to process sorted data much more efficiently.

julia> unique!(B)
3-element Vector{Int64}:
  6
  7
 42
```
