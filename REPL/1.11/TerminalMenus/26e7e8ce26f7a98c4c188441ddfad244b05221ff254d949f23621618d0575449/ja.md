```
MultiSelectConfig(; charset=:ascii, checked::String, unchecked::String, kwargs...)
```

複数選択メニューの動作をキーワード引数で設定します：

  * `checked` は、オプションが選択されたときに表示される文字列です。デフォルトは `charset` に応じて "[X]" または "✓" です。
  * `unchecked` は、オプションが選択されていないときに表示される文字列です。デフォルトは `charset` に応じて "[ ]" または "⬚" です。

その他のキーワード引数は [`TerminalMenus.Config`](@ref) に記載されている通りです。`checked` と `unchecked` は自動的には表示されず、あなたの `writeline` メソッドで表示する必要があります。

!!! compat "Julia 1.6"
    `MultiSelectConfig` は Julia 1.6 から利用可能です。古いリリースではグローバル `CONFIG` を使用してください。

