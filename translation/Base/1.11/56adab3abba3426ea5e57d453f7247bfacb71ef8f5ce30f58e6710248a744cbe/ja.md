```
findnext(ch::AbstractChar, string::AbstractString, start::Integer)
```

文字 `ch` の次の出現を、位置 `start` から始めて `string` 内で見つけます。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


# 例

```jldoctest
julia> findnext('z', "Hello to the world", 1) === nothing
true

julia> findnext('o', "Hello to the world", 6)
8
```
