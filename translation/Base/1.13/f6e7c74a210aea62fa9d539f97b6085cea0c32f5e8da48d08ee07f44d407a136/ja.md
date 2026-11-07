```julia
unique(itr)
```

`itr` コレクションの要素のうち、[`isequal`](@ref) および [`hash`](@ref) によって同値と判定される要素を一つずつ含む配列を返します。同値な要素のうち、元のコレクションで最初に現れる要素の順序を保ちます。入力の要素型は保持されます。

関連項目: [`unique!`](@ref)、[`allunique`](@ref)、[`allequal`](@ref)。

# Examples

```jldoctest
julia> unique([1, 2, 6, 2])
3-element Vector{Int64}:
 1
 2
 6

julia> unique(Real[1, 1.0, 2])
2-element Vector{Real}:
 1
 2
```
