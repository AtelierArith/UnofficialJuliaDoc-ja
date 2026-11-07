```julia
dlopen(libfile::AbstractString [, flags::Integer]; throw_error:Bool = true)
```

共有ライブラリを読み込み、不透明なハンドルを返します。

定数 `dlext`（`.so`、`.dll`、または `.dylib`）で指定される拡張子は、必要に応じて自動的に追加されるため、`libfile` 文字列から省略できます。`libfile` が絶対パスでない場合、配列 `DL_LOAD_PATH` 内のパスを検索して `libfile` を探し、その後、システムのロードパスを検索します。

省略可能な flags 引数には、`RTLD_LOCAL`、`RTLD_GLOBAL`、`RTLD_LAZY`、`RTLD_NOW`、`RTLD_NODELETE`、`RTLD_NOLOAD`、`RTLD_DEEPBIND`、`RTLD_FIRST` のうち、0 個以上をビット単位の OR で組み合わせて指定します。これらは可能であれば POSIX（および／または GNU libc、MacOS）の dlopen コマンドに対応するフラグへ変換され、指定した機能が現在のプラットフォームで利用できない場合は無視されます。デフォルトのフラグはプラットフォームによって異なります。MacOS ではデフォルトの `dlopen` フラグは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` ですが、その他のプラットフォームでは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL` です。これらのフラグは、動的ライブラリローダーがライブラリ参照をエクスポートされたシンボルにバインドする際の動作や、バインドされた参照をプロセス内のローカルスコープとグローバルスコープのどちらに置くかを、デフォルト以外に設定するために重要です。たとえば `RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` を指定すると、そのライブラリのシンボルを他の共有ライブラリから利用できるようになり、共有ライブラリ間に依存関係がある場合に役立ちます。

ライブラリが見つからない場合、このメソッドはエラーをスローします。ただし、キーワード引数 `throw_error` に `false` を指定した場合は、`nothing` を返します。

!!! note
    Julia 1.6 以降では、このメソッドは `@executable_path/` で始まるパスを Julia 実行ファイルへのパスに置き換えるため、相対パスを使った再配置可能な読み込みが可能です。Julia 1.5 以前では、これは macOS でのみ機能していました。

