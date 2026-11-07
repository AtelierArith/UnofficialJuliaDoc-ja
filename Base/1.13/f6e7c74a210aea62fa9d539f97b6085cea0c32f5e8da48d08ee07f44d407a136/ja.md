```julia
unique(itr)
```

`itr`で指定されたコレクションから、[`isequal`](@ref)および[`hash`](@ref)に従って一意な要素のみを含む配列を返します。同値な要素の各集合については、元のコレクションで最初に現れた要素の順序を保ちます。入力の要素型は保持されます。

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
