```
findprev(ch::AbstractChar, string::AbstractString, start::Integer)
```

文字 `ch` の `string` 内の前の出現を、位置 `start` から探します。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


# 例

```jldoctest
julia> findprev('z', "Hello to the world", 18) === nothing
true

julia> findprev('o', "Hello to the world", 18)
15
```
