```
popfirst!(collection) -> item
```

コレクションから最初の `item` を削除します。

この関数は多くの他のプログラミング言語では `shift` と呼ばれています。

参照: [`pop!`](@ref), [`popat!`](@ref), [`delete!`](@ref).

# 例

```jldoctest
julia> A = [1, 2, 3, 4, 5, 6]
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6

julia> popfirst!(A)
1

julia> A
5-element Vector{Int64}:
 2
 3
 4
 5
 6
```
