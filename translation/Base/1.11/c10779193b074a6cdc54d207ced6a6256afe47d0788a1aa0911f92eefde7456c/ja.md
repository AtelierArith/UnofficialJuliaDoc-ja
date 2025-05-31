```
findfirst(ch::AbstractChar, string::AbstractString)
```

文字 `ch` の最初の出現を `string` で見つけます。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


# 例

```jldoctest
julia> findfirst('a', "happy")
2

julia> findfirst('z', "happy") === nothing
true
```
