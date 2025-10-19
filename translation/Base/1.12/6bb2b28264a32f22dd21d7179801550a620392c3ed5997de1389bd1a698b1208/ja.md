```julia
Char(c::Union{Number,AbstractChar})
```

`Char`は、Juliaにおける文字のデフォルト表現である32ビット[`AbstractChar`](@ref)型です。`Char`は、文字リテラル（例：`'x'`）に使用される型であり、[`String`](@ref)の要素型でもあります。

`String`に格納された任意のバイトストリームを損失なく表現するために、`Char`値はUnicodeコードポイントに変換できない情報を格納することがあります。このような`Char`を`UInt32`に変換するとエラーが発生します。`[`isvalid(c::Char)`](@ref)`関数を使用して、`c`が有効なUnicode文字を表しているかどうかを照会できます。
