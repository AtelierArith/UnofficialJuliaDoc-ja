```
@r_str -> Regex
```

Construct a regex, such as `r"^[a-z]*$"`, without interpolation and unescaping (except for quotation mark `"` which still has to be escaped). The regex also accepts one or more flags, listed after the ending quote, to change its behaviour:

  * `i` enables case-insensitive matching
  * `m` treats the `^` and `$` tokens as matching the start and end of individual lines, as opposed to the whole string.
  * `s` allows the `.` modifier to match newlines.
  * `x` enables "free-spacing mode": whitespace between regex tokens is ignored except when escaped with `\`,  and `#` in the regex is treated as starting a comment (which is ignored to the line ending).
  * `a` enables ASCII mode (disables `UTF` and `UCP` modes). By default `\B`, `\b`, `\D`, `\d`, `\S`, `\s`, `\W`, `\w`, etc. match based on Unicode character properties. With this option, these sequences only match ASCII characters. This includes `\u` also, which will emit the specified character value directly as a single byte, and not attempt to encode it into UTF-8. Importantly, this option allows matching against invalid UTF-8 strings, by treating both matcher and target as simple bytes (as if they were ISO/IEC 8859-1 / Latin-1 bytes) instead of as character encodings. In this case, this option is often combined with `s`. This option can be further refined by starting the pattern with (*UCP) or (*UTF).

See [`Regex`](@ref) if interpolation is needed.

# Examples

```jldoctest
julia> match(r"a+.*b+.*?d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
RegexMatch("angry,\nBad world")
```

This regex has the first three flags enabled.
