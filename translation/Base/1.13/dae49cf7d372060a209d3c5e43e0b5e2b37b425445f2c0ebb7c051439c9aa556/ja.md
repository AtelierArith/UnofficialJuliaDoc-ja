```julia
last(itr, n::Integer)
```

反復可能なコレクション`itr`の末尾から`n`個の要素を取得します。`itr`の長さが足りない場合は、取得できる分だけ返します。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6以降が必要です。


# Examples

```jldoctest
julia> last(["foo", "bar", "qux"], 2)
2-element Vector{String}:
 "bar"
 "qux"

julia> last(1:6, 10)
1:6

julia> last(Float64[], 1)
Float64[]
```
