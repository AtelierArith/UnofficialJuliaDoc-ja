```
ansi_4bit_color_code(color::Symbol, background::Bool=false)
```

`color`の色コード（30-37, 40-47, 90-97, 100-107）を整数として提供します。`background`が設定されている場合は背景のバリアントが提供され、それ以外の場合は提供されたコードは前景色を設定するためのものです。
