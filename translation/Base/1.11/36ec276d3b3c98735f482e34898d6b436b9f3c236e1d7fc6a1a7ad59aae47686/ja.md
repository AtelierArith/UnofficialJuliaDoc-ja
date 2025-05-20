```
^(s::Regex, n::Integer) -> Regex
```

正規表現を `n` 回繰り返します。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


# 例

```jldoctest
julia> r"Test "^2
r"(?:Test ){2}"

julia> match(r"Test "^2, "Test Test ")
RegexMatch("Test Test ")
```
