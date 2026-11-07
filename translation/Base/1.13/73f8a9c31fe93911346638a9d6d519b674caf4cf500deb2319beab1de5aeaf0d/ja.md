```julia
*(s::Regex, t::Union{Regex,AbstractString,AbstractChar})::Regex
*(s::Union{Regex,AbstractString,AbstractChar}, t::Regex)::Regex
```

正規表現、文字列、文字を連結して、[`Regex`](@ref)を生成します。文字列と文字の引数は、結果の正規表現内で完全一致するように扱われます。つまり、含まれる文字は特殊な意味を持たず（「\Q」と「\E」で囲まれ）、そのまま照合されます。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。


# Examples

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
