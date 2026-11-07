```julia
termcolor(io::IO, color::SimpleColor, category::Char)
```

`category`のスロットを`color`に設定するSGRコードを、`io`に出力します。`category`は、次のように設定されます。

  * `'3'`は前景色を設定します
  * `'4'`は背景色を設定します
  * `'5'`は下線の色を設定します

`color`が`SimpleColor{Symbol}`の場合、値は`ANSI_4BIT_COLORS`の要素である必要があります。それ以外の値を指定すると、色はリセットされます。

`color`が`SimpleColor{RGBTuple}`であり、`get_have_truecolor()`がtrueを返す場合は、24ビットカラーが使用されます。それ以外の場合は、`color`の8ビット近似値が使用されます。
