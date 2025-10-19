```julia
escape_string(str::AbstractString[, esc]; keep=(), ascii=false, fullhex=false)::AbstractString
escape_string(io, str::AbstractString[, esc]; keep=())::Nothing
```

General escaping of traditional C and Unicode escape sequences. The first form returns the escaped string, the second prints the result to `io`.

Backslashes (`\`) are escaped with a double-backslash (`"\\"`). Non-printable characters are escaped either with their standard C escape codes, `"\0"` for NUL (if unambiguous), unicode code point (`"\u"` prefix) or hex (`"\x"` prefix).

The optional `esc` argument specifies any additional characters that should also be escaped by a prepending backslash (`"` is also escaped by default in the first form).

The argument `keep` specifies a collection of characters which are to be kept as they are. Notice that `esc` has precedence here.

The argument `ascii` can be set to `true` to escape all non-ASCII characters, whereas the default `ascii=false` outputs printable Unicode characters as-is. (`keep` takes precedence over `ascii`.)

The argument `fullhex` can be set to `true` to require all `\u` escapes to be printed with 4 hex digits, and `\U` escapes to be printed with 8 hex digits, whereas by default (`fullhex=false`) they are printed with fewer digits if possible (omitting leading zeros).

See also [`unescape_string`](@ref) for the reverse operation.

!!! compat "Julia 1.7"
    The `keep` argument is available as of Julia 1.7.


!!! compat "Julia 1.12"
    The `ascii` and `fullhex` arguments require Julia 1.12.


# Examples

```jldoctest
julia> escape_string("aaa\nbbb")
"aaa\\nbbb"

julia> escape_string("aaa\nbbb"; keep = '\n')
"aaa\nbbb"

julia> escape_string("\xfe\xff") # invalid utf-8
"\\xfe\\xff"

julia> escape_string(string('\u2135','\0')) # unambiguous
"ℵ\\0"

julia> escape_string(string('\u2135','\0','0')) # \0 would be ambiguous
"ℵ\\x000"
```
