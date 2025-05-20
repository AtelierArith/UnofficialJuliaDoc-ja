```
 isidentifier(s) -> Bool
```

Return whether the symbol or string `s` contains characters that are parsed as a valid ordinary identifier (not a binary/unary operator) in Julia code; see also [`Base.isoperator`](@ref).

Internally Julia allows any sequence of characters in a `Symbol` (except `\0`s), and macros automatically use variable names containing `#` in order to avoid naming collision with the surrounding code. In order for the parser to recognize a variable, it uses a limited set of characters (greatly extended by Unicode). `isidentifier()` makes it possible to query the parser directly whether a symbol contains valid characters.

# Examples

```jldoctest
julia> Meta.isidentifier(:x), Meta.isidentifier("1x")
(true, false)
```
