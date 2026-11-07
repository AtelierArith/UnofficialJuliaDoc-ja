```julia
Ryu.writeexp(x, precision, plus=false, space=false, hash=false, expchar=UInt8('e'), decchar=UInt8('.'), trimtrailingzeros=false)
Ryu.writeexp(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

浮動小数点値 `x` を、科学表記の10進文字列に変換します。この関数を使うと、`%e` の printf 形式を実現できます。2つ目のメソッドでは、バイトバッファと位置を直接渡せます。呼び出し側は、10進文字列全体を格納できる十分な領域がバッファにあることを確認してください。

出力形式には、次のようなオプションがあります。

  * `plus`: `x` が正の場合、10進文字列の先頭に `'+'` 文字を付けます
  * `space`: `x` が正の場合、10進文字列の先頭に `' '` 文字を付けます。ただし、`plus=true` が指定されている場合は上書きされます
  * `hash`: 精度を満たすために追加の桁が不要な場合でも、小数点を出力するかどうか
  * `precision`: 10進文字列に含める有効桁数の最小値。必要に応じて、埋め合わせ用に `'0'` 文字が追加されます
  * `expchar`: 科学表記の指数部に使用する文字
  * `decchar`: 小数点に使用する文字
  * `trimtrailingzeros`: 末尾のゼロを削除するかどうか
