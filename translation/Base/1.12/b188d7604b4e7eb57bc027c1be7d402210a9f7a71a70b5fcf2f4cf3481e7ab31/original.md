```julia
unescape_string(str::AbstractString, keep = ())::AbstractString
unescape_string(io, s::AbstractString, keep = ())::Nothing
```

General unescaping of traditional C and Unicode escape sequences. The first form returns the escaped string, the second prints the result to `io`. The argument `keep` specifies a collection of characters which (along with backlashes) are to be kept as they are.

The following escape sequences are recognised:

  * Escaped backslash (`\\`)
  * Escaped double-quote (`\"`)
  * Standard C escape sequences (`\a`, `\b`, `\t`, `\n`, `\v`, `\f`, `\r`, `\e`)
  * Unicode BMP code points (`\u` with 1-4 trailing hex digits)
  * All Unicode code points (`\U` with 1-8 trailing hex digits; max value = 0010ffff)
  * Hex bytes (`\x` with 1-2 trailing hex digits)
  * Octal bytes (`\` with 1-3 trailing octal digits)

See also [`escape_string`](@ref).

# Examples

```jldoctest
julia> unescape_string("aaa\\nbbb") # C escape sequence
"aaa\nbbb"

julia> unescape_string("\\u03c0") # unicode
"π"

julia> unescape_string("\\101") # octal
"A"

julia> unescape_string("aaa \\g \\n", ['g']) # using `keep` argument
"aaa \\g \n"
```
