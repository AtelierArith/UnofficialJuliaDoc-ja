```julia
writeline(buf::IO, m::AbstractMenu, idx::Int, iscursor::Bool)
```

インデックス `idx` のオプションを `buf` に書き込みます。`iscursor` が `true` の場合、このアイテムが現在のカーソル位置にあることを示します（"Enter" を押すことで選択されるもの）。

もし `m` が `ConfiguredMenu` の場合、`TerminalMenus` はカーソルインジケーターを表示します。そうでない場合、呼び出し元がその表示を処理することが期待されます。

!!! compat "Julia 1.6"
    `writeline` は Julia 1.6 以上が必要です。

    古いバージョンの Julia では、これは `writeLine(buf::IO, m::AbstractMenu, idx, iscursor::Bool)` であり、`m` は未設定であると仮定されます。選択とカーソルインジケーターは `TerminalMenus.CONFIG` から取得できます。

    この古い関数はすべての Julia 1.x バージョンでサポートされていますが、Julia 2.0 では削除される予定です。


```
