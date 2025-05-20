```
Unicode.julia_chartransform(c::Union{Char,Integer})
```

Unicode 文字 (`Char`) または コードポイント (`Integer`) `c` を、Julia パーサー内で使用されるカスタム同等性に従って、対応する「同等の」文字またはコードポイントにマップします（NFC 正規化に加えて）。

例えば、`'µ'` (U+00B5 マイクロ) は、Julia のパーサーによって `'μ'` (U+03BC ミュー) と同等と見なされるため、`julia_chartransform` はこの変換を行い、他の文字は変更しません：

```jldoctest
julia> Unicode.julia_chartransform('µ')
'μ': Unicode U+03BC (category Ll: Letter, lowercase)

julia> Unicode.julia_chartransform('x')
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

`julia_chartransform` は、Julia パーサーによって使用される正規化を模倣するために、[`Unicode.normalize`](@ref) 関数に渡すのに主に便利です：

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
    この関数は Julia 1.8 で導入されました。

