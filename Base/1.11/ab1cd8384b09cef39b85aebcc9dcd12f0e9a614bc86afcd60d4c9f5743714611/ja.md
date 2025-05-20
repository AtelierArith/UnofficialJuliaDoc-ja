```
*(s::Regex, t::Union{Regex,AbstractString,AbstractChar}) -> Regex
*(s::Union{Regex,AbstractString,AbstractChar}, t::Regex) -> Regex
```

正規表現、文字列、および/または文字を連結し、[`Regex`](@ref)を生成します。文字列および文字の引数は、結果の正規表現で正確に一致する必要があり、含まれる文字は特別な意味を持たない（"\Q"および"\E"で引用される）ことを意味します。

!!! compat "Julia 1.3"
    このメソッドは少なくともJulia 1.3を必要とします。


# 例

```jldoctest
julia> match(r"Hello|Good bye" * ' ' * "world", "Hello world")
RegexMatch("Hello world")

julia> r = r"a|b" * "c|d"
r"(?:a|b)\Qc|d\E"

julia> match(r, "ac") == nothing
true

julia> match(r, "ac|d")
RegexMatch("ac|d")
```
