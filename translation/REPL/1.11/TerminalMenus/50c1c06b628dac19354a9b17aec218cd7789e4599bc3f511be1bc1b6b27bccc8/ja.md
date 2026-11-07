```julia
MultiSelectConfig(; charset=:ascii, checked::String, unchecked::String, kwargs...)
```

キーワード引数を使って、複数選択メニューの動作を設定します。

  * `checked` は、オプションが選択されているときに表示する文字列です。デフォルトは、`charset` に応じて「[X]」または「✓」です。
  * `unchecked` は、オプションが選択されていないときに表示する文字列です。デフォルトは、`charset` に応じて「[ ]」または「⬚」です。

その他のキーワード引数については、[`TerminalMenus.Config`](@ref) の説明を参照してください。`checked` と `unchecked` は自動では表示されないため、`writeline` メソッドで表示してください。

!!! compat "Julia 1.6"
    `MultiSelectConfig` は Julia 1.6 以降で利用できます。それ以前のバージョンでは、グローバルな `CONFIG` を使用してください。

