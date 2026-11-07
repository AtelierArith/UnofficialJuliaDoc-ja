```julia
get_extension(parent::Module, extension::Symbol)
```

`parent` の `extension` に対応するモジュールを返します。拡張機能が読み込まれていない場合は、`nothing` を返します。
