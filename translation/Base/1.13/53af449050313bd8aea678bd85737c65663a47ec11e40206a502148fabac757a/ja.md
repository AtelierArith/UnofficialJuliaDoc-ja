```julia
popfirst!(collection) -> item
```

`collection`から最初の`item`を削除します。

この関数は、他の多くのプログラミング言語では`shift`と呼ばれます。

関連項目: [`pop!`](@ref)、[`popat!`](@ref)、[`delete!`](@ref)。

# Examples

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
