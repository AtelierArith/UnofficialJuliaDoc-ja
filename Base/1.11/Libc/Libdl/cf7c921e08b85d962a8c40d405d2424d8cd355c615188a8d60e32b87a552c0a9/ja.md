```
dlopen(libfile::AbstractString [, flags::Integer]; throw_error:Bool = true)
```

共有ライブラリをロードし、不透明なハンドルを返します。

定数 `dlext`（`.so`、`.dll`、または`.dylib`）によって指定された拡張子は、必要に応じて自動的に追加されるため、`libfile` 文字列から省略できます。`libfile` が絶対パス名でない場合、配列 `DL_LOAD_PATH` 内のパスが `libfile` を検索し、その後にシステムロードパスが続きます。

オプションのフラグ引数は、`RTLD_LOCAL`、`RTLD_GLOBAL`、`RTLD_LAZY`、`RTLD_NOW`、`RTLD_NODELETE`、`RTLD_NOLOAD`、`RTLD_DEEPBIND`、および `RTLD_FIRST` のゼロまたはそれ以上のビット単位の論理和です。これらは、可能であればPOSIX（および/またはGNU libcおよび/またはMacOS）のdlopenコマンドの対応するフラグに変換されます。指定された機能が現在のプラットフォームで利用できない場合は無視されます。デフォルトのフラグはプラットフォーム固有です。MacOSではデフォルトの `dlopen` フラグは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` ですが、他のプラットフォームではデフォルトは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL` です。これらのフラグの重要な使用法は、動的ライブラリローダーがライブラリ参照をエクスポートされたシンボルにバインドする際のデフォルト以外の動作を指定し、バインドされた参照がプロセスローカルまたはグローバルスコープに配置されるかどうかを指定することです。たとえば、`RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` は、ライブラリのシンボルが他の共有ライブラリで使用できるようにし、共有ライブラリ間の依存関係がある状況に対処します。

ライブラリが見つからない場合、このメソッドはエラーをスローします。ただし、キーワード引数 `throw_error` が `false` に設定されている場合、このメソッドは `nothing` を返します。

!!! note
    Julia 1.6以降、このメソッドは `@executable_path/` で始まるパスをJulia実行可能ファイルへのパスに置き換え、再配置可能な相対パスのロードを可能にします。Julia 1.5以前では、これはmacOSでのみ機能しました。

