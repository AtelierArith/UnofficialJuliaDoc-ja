```julia
Ryu.writefixed(x, precision, plus=false, space=false, hash=false, decchar=UInt8('.'), trimtrailingzeros=false)
Ryu.writefixed(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

浮動小数点値 `x` を、指定した精度の「固定」サイズの10進文字列に変換します。この関数を使うと、`%f` の printf 形式を実現できます。2番目のメソッドでは、バイトバッファと位置を直接渡せます。呼び出し側は、10進文字列全体を格納できる十分な領域がバッファにあることを確認してください。

出力形式には、次のようなオプションがあります。

  * `plus`: `x` が正の場合、10進文字列の先頭に `'+'` 文字を付けます
  * `space`: `x` が正の場合、10進文字列の先頭に `' '` 文字を付けます。ただし、`plus=true` が指定されている場合は上書きされます
  * `hash`: 精度を満たすために追加の桁が不要な場合でも、小数点を出力するかどうか
  * `precision`: 10進文字列に含める有効桁数の最小値。必要に応じて、パディング用に `'0'` 文字が追加されます
  * `decchar`: 使用する小数点文字
  * `trimtrailingzeros`: 小数部の末尾のゼロを削除するかどうか
