```
termcolor(io::IO, color::SimpleColor, category::Char)
```

`category`のスロットを`color`に設定するためのSGRコードを`io`に印刷します。`category`は以下のように設定されます：

  * `'3'`は前景色を設定します
  * `'4'`は背景色を設定します
  * `'5'`は下線色を設定します

`color`が`SimpleColor{Symbol}`の場合、その値は`ANSI_4BIT_COLORS`のメンバーである必要があります。それ以外の値は色をリセットします。

`color`が`SimpleColor{RGBTuple}`であり、`get_have_truecolor()`がtrueを返す場合、24ビットカラーが使用されます。そうでない場合、`color`の8ビット近似が使用されます。
