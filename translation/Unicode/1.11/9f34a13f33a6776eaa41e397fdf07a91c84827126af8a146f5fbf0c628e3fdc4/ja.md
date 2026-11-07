```julia
Unicode.julia_chartransform(c::Union{Char,Integer})
```

Unicode文字（`Char`）またはコードポイント（`Integer`）である`c`を、Juliaのパーサーが（NFC正規化に加えて）使用する独自の等価関係に従って、それぞれ対応する「等価な」文字またはコードポイントに変換します。

たとえば、Juliaのパーサーは`'µ'`（U+00B5 micro）を`'μ'`（U+03BC mu）と等価に扱うため、`julia_chartransform`は他の文字を変更せずに、この変換を行います。

```jldoctest
julia> Unicode.julia_chartransform('µ')
'μ': Unicode U+03BC (category Ll: Letter, lowercase)

julia> Unicode.julia_chartransform('x')
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

`julia_chartransform`は主に、[`Unicode.normalize`](@ref)関数に渡して、Juliaのパーサーが行う正規化を再現する際に役立ちます。

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
    この関数はJulia 1.8で導入されました。

