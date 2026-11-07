```julia
graphemes(s::AbstractString, m:n)::SubString
```

[`SubString`](@ref) を返します。これは、文字列 `s` の `m` 番目から `n` 番目までの書記素からなる `s` です。第 2 引数 `m:n` は整数値の [`AbstractUnitRange`](@ref) です。

大まかに言えば、文字列内でユーザーが認識する「文字」のうち、`m:n` 番目に相当します。たとえば、

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

これは `"exposé"` の 3 番目から *7* 番目までのコードポイント（[`Char`](@ref)）に相当します。書記素 `"é"` は、実際には 2 つの Unicode コードポイント（`'e'` と、それに続く結合文字のアキュートアクセント U+0301）で構成されているためです。

書記素の境界を見つけるには文字列の内容を反復処理する必要があるため、`graphemes(s, m:n)` 関数は、部分文字列の末尾より前にある文字列の長さ（コードポイント数）に比例した時間を要します。

!!! compat "Julia 1.9"
    `graphemes` の `m:n` 引数には Julia 1.9 が必要です。

