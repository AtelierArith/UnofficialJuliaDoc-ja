```julia
Ryu.writeshortest(x, plus=false, space=false, hash=true, precision=-1, expchar=UInt8('e'), padexp=false, decchar=UInt8('.'), typed=false, compact=false)
Ryu.writeshortest(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

浮動小数点値 `x` を、同じ値に再度パースできる「最短」の10進文字列に変換します。この関数を使うと、`%g` の printf 書式を実現できます。2番目のメソッドでは、バイトバッファと位置を直接渡せます。呼び出し側は、10進文字列全体を格納できる十分な領域がバッファにあることを確認してください。

出力形式には、次のようなオプションがあります。

  * `plus`: 正の `x` の場合、10進文字列の先頭に `'+'` 文字を付けます
  * `space`: 正の `x` の場合、10進文字列の先頭に `' '` 文字を付けます。`plus=true` が指定されている場合は、そちらが優先されます
  * `hash`: 精度を満たすために追加の桁が不要な場合でも、小数点を出力するかどうか
  * `precision`: 10進文字列に含める最小桁数。必要に応じて、パディング用に `'0'` 文字が追加されます
  * `expchar`: 科学表記法の指数部に使用する文字
  * `padexp`: 指数が1桁の場合（例: `e+1` が `e+01` になる場合）でも、常に2桁で出力するかどうか
  * `decchar`: 小数点に使用する文字
  * `typed`: `Float16` / `Float32` に追加の型情報を出力するかどうか
  * `compact`: 出力を有効数字6桁に制限します
