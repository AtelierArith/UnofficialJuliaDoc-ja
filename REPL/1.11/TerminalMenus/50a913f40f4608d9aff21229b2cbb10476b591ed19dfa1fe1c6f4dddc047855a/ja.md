```julia
MultiSelectConfig(; charset=:ascii, checked::String, unchecked::String, kwargs...)
```

複数選択メニューの動作をキーワード引数を通じて設定します：

  * `checked` は、オプションが選択されたときに印刷される文字列です。デフォルトは `charset` に応じて "[X]" または "✓" です。
  * `unchecked` は、オプションが選択されていないときに印刷される文字列です。デフォルトは `charset` に応じて "[ ]" または "⬚" です。

他のすべてのキーワード引数は [`TerminalMenus.Config`](@ref) に記載されている通りです。`checked` と `unchecked` は自動的には印刷されず、あなたの `writeline` メソッドによって印刷されるべきです。

!!! compat "Julia 1.6"
    `MultiSelectConfig` は Julia 1.6 から利用可能です。古いリリースではグローバル `CONFIG` を使用してください。

