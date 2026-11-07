```julia
findnext(ch::AbstractChar, string::AbstractString, start::Integer)
```

位置 `start` から検索を開始し、`string` 内で文字 `ch` が次に現れる位置を探します。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。


# Examples

```jldoctest
julia> findnext('z', "Hello to the world", 1) === nothing
true

julia> findnext('o', "Hello to the world", 6)
8
```
