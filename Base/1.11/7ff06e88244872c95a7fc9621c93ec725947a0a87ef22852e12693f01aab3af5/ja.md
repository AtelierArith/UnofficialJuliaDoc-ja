```
findlast(ch::AbstractChar, string::AbstractString)
```

文字 `ch` の `string` 内での最後の出現を見つけます。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


# 例

```jldoctest
julia> findlast('p', "happy")
4

julia> findlast('z', "happy") === nothing
true
```
