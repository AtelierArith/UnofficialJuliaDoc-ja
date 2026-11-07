```julia
findfirst(ch::AbstractChar, string::AbstractString)
```

`string` 内で、文字 `ch` が最初に現れる位置を検索します。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。


# Examples

```jldoctest
julia> findfirst('a', "happy")
2

julia> findfirst('z', "happy") === nothing
true
```
