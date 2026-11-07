```julia
_printstyled(io::IO, text;
             fgcolor=nothing, bgcolor=nothing, href=nothing)
```

Base.printstyledと似ていますが、トゥルーカラー対応端末で前景色と背景色にRGBカラーを指定できるほか、ハイパーリンクも設定できます。色は、`Base.printstyled`のような標準色名、256色端末用の整数、またはトゥルーカラー対応端末用の`0 <= r <= 255`などを使った(r,g,b)の3つ組で指定できます。

  * `fgcolor` - 前景色を設定
  * `bgcolor` - 背景色を設定
  * `href`    - ハイパーリンク参照を設定
