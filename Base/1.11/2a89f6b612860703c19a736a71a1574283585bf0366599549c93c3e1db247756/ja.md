```
last(itr, n::Integer)
```

イテラブルコレクション `itr` の最後の `n` 要素を取得します。`itr` が十分に長くない場合は、より少ない要素が返されます。

!!! compat "Julia 1.6"
    このメソッドは少なくとも Julia 1.6 を必要とします。


# 例

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
