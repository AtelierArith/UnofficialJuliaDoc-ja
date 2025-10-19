```julia
first(itr, n::Integer)
```

イテラブルコレクション `itr` の最初の `n` 要素を取得します。`itr` が十分に長くない場合は、より少ない要素が返されます。

関連: [`startswith`](@ref), [`Iterators.take`](@ref).

!!! compat "Julia 1.6"
    このメソッドは少なくとも Julia 1.6 を必要とします。


# 例

```jldoctest
julia> first(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "foo"
 "bar"

julia> first(1:6, 10)
1:6

julia> first(Bool[], 1)
Bool[]
```
