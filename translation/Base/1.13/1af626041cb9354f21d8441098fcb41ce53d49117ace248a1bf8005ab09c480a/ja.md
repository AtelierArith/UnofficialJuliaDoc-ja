```julia
first(itr, n::Integer)
```

反復可能なコレクション `itr` の先頭から `n` 個の要素を取得します。ただし、`itr` の長さが足りない場合は、取得できる要素数だけを返します。

関連項目: [`startswith`](@ref)、[`Iterators.take`](@ref)。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6 以降が必要です。


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
