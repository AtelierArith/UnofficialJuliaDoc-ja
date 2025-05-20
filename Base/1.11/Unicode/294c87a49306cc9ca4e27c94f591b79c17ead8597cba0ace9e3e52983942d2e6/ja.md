```
lowercase(c::AbstractChar)
```

`c`を小文字に変換します。

関連情報としては[`uppercase`](@ref)、[`titlecase`](@ref)があります。

# 例

```jldoctest
julia> lowercase('A')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> lowercase('Ö')
'ö': Unicode U+00F6 (category Ll: Letter, lowercase)
```
