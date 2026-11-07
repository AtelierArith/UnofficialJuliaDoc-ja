```julia
findlast(ch::AbstractChar, string::AbstractString)
```

`string` 内で、文字 `ch` が最後に現れる位置を検索します。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。


# Examples

```jldoctest
julia> findlast('p', "happy")
4

julia> findlast('z', "happy") === nothing
true
```
