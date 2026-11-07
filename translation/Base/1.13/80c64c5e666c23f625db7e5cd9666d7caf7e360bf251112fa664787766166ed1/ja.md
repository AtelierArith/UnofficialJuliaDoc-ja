```julia
Char(c::Union{Number,AbstractChar})
```

`Char`は、Juliaで文字を表すデフォルトの32ビット[`AbstractChar`](@ref)型です。`Char`は、`'x'`のような文字リテラルに使われる型であり、[`String`](@ref)の要素型でもあります。

`String`に格納された任意のバイトストリームを損失なく表現するため、`Char`の値には、Unicodeコードポイントに変換できない情報が含まれる場合があります。そのような`Char`を`UInt32`に変換すると、エラーが発生します。[`isvalid(c::Char)`](@ref)関数を使うと、`c`が有効なUnicode文字を表しているかどうかを調べられます。
