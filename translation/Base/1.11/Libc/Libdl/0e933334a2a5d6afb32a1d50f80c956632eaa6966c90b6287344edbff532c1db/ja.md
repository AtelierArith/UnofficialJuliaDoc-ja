```
LazyLibrary(name, flags = <default dlopen flags>,
            dependencies = LazyLibrary[], on_load_callback = nothing)
```

最初の使用時に `dlopen()`、`dlsym()`、または `ccall()` の使用で自分自身とその依存関係を開く遅延読み込みライブラリを表します。この構造体は `on_load_callback` を介して最初の読み込み時に任意のコードを実行する能力を持っていますが、`ccall()` が大量のJuliaコードを実行することは期待されていないため、注意して使用する必要があります。`on_load_callback` 内から `ccall()` を呼び出すことはできますが、現在のライブラリとその依存関係のみに対してのみ行うべきであり、ユーザーは on load callback 内のタスクに対して `wait()` を呼び出すべきではありません。
