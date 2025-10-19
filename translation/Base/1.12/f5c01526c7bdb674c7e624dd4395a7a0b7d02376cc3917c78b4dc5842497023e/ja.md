```julia
unique!(A::AbstractVector)
```

[`isequal`](@ref) および [`hash`](@ref) によって決定される重複アイテムを削除し、修正された `A` を返します。`unique!` は、`A` の要素を発生する順序で返します。返されるデータの順序を気にしない場合は、`(sort!(A); unique!(A))` を呼び出す方が、`A` の要素がソート可能である限り、はるかに効率的です。

# 例

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

julia> sort!(B);  # unique! はソートされたデータをより効率的に処理できます。

julia> unique!(B)
3-element Vector{Int64}:
  6
  7
 42
```
