```
graphemes(s::AbstractString, m:n) -> SubString
```

`s`の`m`番目から`n`番目のグラフェムからなる[`SubString`](@ref)を返します。ここで、2番目の引数`m:n`は整数値の[`AbstractUnitRange`](@ref)です。

ざっくり言うと、これは文字列内の`m:n`番目のユーザーが認識する「文字」に対応します。例えば：

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

これは、`"exposé"`の3番目から*7番目*のコードポイント（[`Char`](@ref)）で構成されています。なぜなら、グラフェム`"é"`は実際には*2つ*のUnicodeコードポイント（`'e'`の後に合成文字の急アクセントU+0301が続く）だからです。

グラフェムの境界を見つけるには文字列の内容を反復処理する必要があるため、`graphemes(s, m:n)`関数は部分文字列の終わりまでの文字列の長さ（コードポイントの数）に比例した時間がかかります。

!!! compat "Julia 1.9"
    `graphemes`の`m:n`引数はJulia 1.9を必要とします。

