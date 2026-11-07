```julia
graphemes(s::AbstractString, m:n)::SubString
```

文字列 `s` の第 `m` 書記素から第 `n` 書記素までで構成される、`s` の [`SubString`](@ref) を返します。第2引数 `m:n` は、整数値を取る [`AbstractUnitRange`](@ref) です。

大まかに言えば、これは文字列内でユーザーが「文字」として認識する単位の第 `m:n` 番目に対応します。たとえば、次のようになります。

```jldoctest
julia> s = graphemes("exposé", 3:6)
"posé"

julia> collect(s)
5-element Vector{Char}:
 'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)
 'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)
 's': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)
 'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)
 '́': Unicode U+0301 (category Mn: Mark, nonspacing)
```

これは、`"exposé"` の3番目から *7番目* までのコードポイント（[`Char`](@ref)）で構成されます。書記素 `"é"` は、実際には *2つ* の Unicode コードポイント（`'e'` と、それに続くアキュートアクセントの結合文字 U+0301）から成るためです。

書記素の境界を見つけるには文字列の内容を反復処理する必要があるため、`graphemes(s, m:n)` 関数の実行には、文字列の先頭から部分文字列の末尾までの長さ（コードポイント数）に比例する時間がかかります。

!!! compat "Julia 1.9"
    `graphemes` の `m:n` 引数には Julia 1.9 が必要です。

