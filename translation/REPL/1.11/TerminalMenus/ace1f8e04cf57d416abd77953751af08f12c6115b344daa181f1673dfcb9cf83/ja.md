```julia
config( <see arguments> )
```

グローバルメニューのパラメーターを設定するキーワード専用関数

# Arguments

  * `charset::Symbol=:na`: 使用するUI文字（`:ascii`または`:unicode`）。ほかの引数が指定された場合は上書きされます
  * `cursor::Char='>'|'→'`: カーソルに使用する文字
  * `up_arrow::Char='^'|'↑'`: 上矢印に使用する文字
  * `down_arrow::Char='v'|'↓'`: 下矢印に使用する文字
  * `checked::String="[X]"|"✓"`: チェック済みに使用する文字列
  * `unchecked::String="[ ]"|"⬚")`: 未チェックに使用する文字列
  * `scroll::Symbol=:nowrap`: `:wrap`の場合、カーソルは上下端で折り返します。:`nowrap`の場合、カーソルは折り返しません
  * `supress_output::Bool=false`: 互換性のために残されている引数ですが、無視されます。代わりに`request`にキーワード引数として`suppress_output`を渡してください。
  * `ctrl_c_interrupt::Bool=true`: `false`の場合、^Cで空を返します。`true`の場合、^CでInterruptException()をスローします

!!! compat "Julia 1.6"
    Julia 1.6以降、`config`は非推奨です。代わりに`Config`または`MultiSelectConfig`を使用してください。

