```
Unicode.julia_chartransform(c::Union{Char,Integer})
```

Map the Unicode character (`Char`) or codepoint (`Integer`) `c` to the corresponding "equivalent" character or codepoint, respectively, according to the custom equivalence used within the Julia parser (in addition to NFC normalization).

For example, `'µ'` (U+00B5 micro) is treated as equivalent to `'μ'` (U+03BC mu) by Julia's parser, so `julia_chartransform` performs this transformation while leaving other characters unchanged:

```jldoctest
julia> Unicode.julia_chartransform('µ')
'μ': Unicode U+03BC (category Ll: Letter, lowercase)

julia> Unicode.julia_chartransform('x')
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

`julia_chartransform` is mainly useful for passing to the [`Unicode.normalize`](@ref) function in order to mimic the normalization used by the Julia parser:

```jldoctest
julia> s = "µö"
"µö"

julia> s2 = Unicode.normalize(s, compose=true, stable=true, chartransform=Unicode.julia_chartransform)
"μö"

julia> collect(s2)
2-element Vector{Char}:
 'μ': Unicode U+03BC (category Ll: Letter, lowercase)
 'ö': Unicode U+00F6 (category Ll: Letter, lowercase)

julia> s2 == string(Meta.parse(s))
true
```

!!! compat "Julia 1.8"
    This function was introduced in Julia 1.8.

