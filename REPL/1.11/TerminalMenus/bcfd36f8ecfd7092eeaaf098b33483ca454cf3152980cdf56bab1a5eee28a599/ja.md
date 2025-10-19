```julia
Config(; scroll_wrap=false, ctrl_c_interrupt=true, charset=:ascii, cursor::Char, up_arrow::Char, down_arrow::Char)
```

キーワード引数を介して選択メニューの動作を設定します：

  * `scroll_wrap`が`true`の場合、メニューは最初または最後のエントリを超えてスクロールするときにラップします
  * `ctrl_c_interrupt`が`true`の場合、ユーザーがメニュー選択中にCtrl-Cを押すと`InterruptException`がスローされます。`false`の場合、[`TerminalMenus.request`](@ref)は[`TerminalMenus.selected`](@ref)からのデフォルトの結果を返します。
  * `charset`は`cursor`、`up_arrow`、および`down_arrow`のデフォルト値に影響し、`:ascii`または`:unicode`にすることができます
  * `cursor`は「Enter」を押すことで選択されるオプションを示すために印刷される文字です。デフォルトは`>`または`→`で、`charset`に依存します。
  * `up_arrow`は表示に最初のエントリが含まれていないときに印刷される文字です。デフォルトは`^`または`↑`で、`charset`に依存します。
  * `down_arrow`は表示に最後のエントリが含まれていないときに印刷される文字です。デフォルトは`v`または`↓`で、`charset`に依存します。

`ConfiguredMenu`のサブタイプは、必要に応じて`cursor`、`up_arrow`、および`down_arrow`を自動的に印刷します。あなたの`writeline`メソッドはそれらを印刷してはいけません。

!!! compat "Julia 1.6"
    `Config`はJulia 1.6以降で利用可能です。古いリリースではグローバル`CONFIG`を使用してください。

