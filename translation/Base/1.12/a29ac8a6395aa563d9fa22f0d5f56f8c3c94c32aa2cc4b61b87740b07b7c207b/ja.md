```julia
unique(itr)
```

コレクション `itr` のユニークな要素のみを含む配列を返します。これは [`isequal`](@ref) と [`hash`](@ref) によって決定され、同等の要素の最初の出現順に表示されます。入力の要素型は保持されます。

関連情報: [`unique!`](@ref), [`allunique`](@ref), [`allequal`](@ref).

# 例

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
