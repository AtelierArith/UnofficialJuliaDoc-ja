```julia
writeline(buf::IO, m::AbstractMenu, idx::Int, iscursor::Bool)
```

インデックス `idx` のオプションを `buf` に書き込みます。`iscursor` が `true` の場合、この項目が現在のカーソル位置（「Enter」キーを押すと選択される項目）にあることを示します。

`m` が `ConfiguredMenu` の場合、`TerminalMenus` がカーソルインジケーターを出力します。それ以外の場合は、呼び出し先が出力を処理することを想定しています。

!!! compat "Julia 1.6"
    `writeline` には Julia 1.6 以降が必要です。

    それ以前の Julia バージョンでは、これは `writeLine(buf::IO, m::AbstractMenu, idx, iscursor::Bool)` であり、`m` は未設定とみなされます。選択インジケーターとカーソルインジケーターは `TerminalMenus.CONFIG` から取得できます。

    この旧関数は Julia 1.x のすべてのバージョンでサポートされていますが、Julia 2.0 で削除される予定です。

