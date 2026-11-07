```julia
first(itr, n::Integer)
```

反復可能なコレクション `itr` の先頭から `n` 個の要素を取得します。ただし、`itr` の要素数が足りない場合は、取得できる分だけ返します。

関連項目: [`startswith`](@ref)、[`Iterators.take`](@ref)。

!!! compat "Julia 1.6"
    このメソッドの使用には Julia 1.6 以降が必要です。


# Examples

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
