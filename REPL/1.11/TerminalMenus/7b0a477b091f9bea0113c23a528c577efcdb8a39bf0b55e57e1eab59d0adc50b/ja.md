```julia
config( <see arguments> )
```

キーワード専用関数でグローバルメニューのパラメータを設定します

# 引数

  * `charset::Symbol=:na`: 使用するUI文字（`:ascii`または`:unicode`）；他の引数によって上書きされます
  * `cursor::Char='>'|'→'`: カーソルに使用する文字
  * `up_arrow::Char='^'|'↑'`: 上矢印に使用する文字
  * `down_arrow::Char='v'|'↓'`: 下矢印に使用する文字
  * `checked::String="[X]"|"✓"`: チェック済みに使用する文字列
  * `unchecked::String="[ ]"|"⬚")`: チェックなしに使用する文字列
  * `scroll::Symbol=:nowrap`: `:wrap`の場合はカーソルを上下にラップし、`:nowrap`の場合はカーソルをラップしません
  * `supress_output::Bool=false`: 無視されるレガシー引数、代わりに`request`にキーワード引数として`suppress_output`を渡してください。
  * `ctrl_c_interrupt::Bool=true`: `false`の場合、^Cで空を返し、`true`の場合、^Cで`InterruptException()`をスローします

!!! compat "Julia 1.6"
    Julia 1.6以降、`config`は非推奨です。代わりに`Config`または`MultiSelectConfig`を使用してください。

