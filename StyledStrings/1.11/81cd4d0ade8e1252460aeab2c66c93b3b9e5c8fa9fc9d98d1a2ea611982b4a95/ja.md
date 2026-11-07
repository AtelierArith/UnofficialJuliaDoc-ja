```julia
ansi_4bit_color_code(color::Symbol, background::Bool=false)
```

`color` の色コード（30～37、40～47、90～97、100～107）を整数で指定します。`background` が設定されている場合は背景色のコードを指定し、設定されていない場合は前景色のコードを指定します。
