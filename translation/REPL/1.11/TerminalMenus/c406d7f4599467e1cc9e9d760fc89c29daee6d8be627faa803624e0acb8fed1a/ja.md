```julia
Config(; scroll_wrap=false, ctrl_c_interrupt=true, charset=:ascii, cursor::Char, up_arrow::Char, down_arrow::Char)
```

キーワード引数を使って、選択メニューの動作を設定します。

  * `scroll_wrap` が `true` の場合、最初の項目より上、または最後の項目より下へスクロールすると、メニューが先頭または末尾に戻ります。
  * `ctrl_c_interrupt` が `true` の場合、メニューの選択中に Ctrl-C を押すと `InterruptException` がスローされます。`false` の場合、[`TerminalMenus.request`](@ref) は [`TerminalMenus.selected`](@ref) のデフォルトの結果を返します。
  * `charset` は `cursor`、`up_arrow`、`down_arrow` のデフォルト値に影響し、`:ascii` または `:unicode` を指定できます。
  * `cursor` は、「Enter」キーを押すと選択される項目を示すために表示される文字です。デフォルトは、`charset` に応じて '>' または '→' です。
  * `up_arrow` は、最初の項目が表示範囲に含まれない場合に表示される文字です。デフォルトは、`charset` に応じて '^' または '↑' です。
  * `down_arrow` は、最後の項目が表示範囲に含まれない場合に表示される文字です。デフォルトは、`charset` に応じて 'v' または '↓' です。

`ConfiguredMenu` のサブタイプでは、必要に応じて `cursor`、`up_arrow`、`down_arrow` が自動的に表示されます。`writeline` メソッドでこれらを表示する必要はありません。

!!! compat "Julia 1.6"
    `Config` は Julia 1.6 以降で利用できます。それ以前のバージョンでは、グローバルな `CONFIG` を使用してください。

