```julia
dlopen(libfile::AbstractString [, flags::Integer]; throw_error:Bool = true)
```

共有ライブラリをロードし、不透明なハンドルを返します。

定数 `dlext` によって与えられる拡張子（`.so`、`.dll`、または `.dylib`）は、必要に応じて `libfile` 文字列から省略できます。`libfile` が絶対パス名でない場合、配列 `DL_LOAD_PATH` 内のパスが `libfile` を検索し、その後にシステムのロードパスが続きます。

オプションのフラグ引数は、`RTLD_LOCAL`、`RTLD_GLOBAL`、`RTLD_LAZY`、`RTLD_NOW`、`RTLD_NODELETE`、`RTLD_NOLOAD`、`RTLD_DEEPBIND`、および `RTLD_FIRST` のゼロまたはそれ以上のビット単位の論理和です。これらは、可能であれば POSIX（および/または GNU libc および/または MacOS）の dlopen コマンドの対応するフラグに変換されます。指定された機能が現在のプラットフォームで利用できない場合は無視されます。デフォルトのフラグはプラットフォームに依存します。MacOS ではデフォルトの `dlopen` フラグは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` ですが、他のプラットフォームではデフォルトは `RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL` です。これらのフラグの重要な使用法は、動的ライブラリローダーがライブラリ参照をエクスポートされたシンボルにバインドする際のデフォルト以外の動作を指定し、バインドされた参照がプロセスローカルまたはグローバルスコープに配置されるかどうかを指定することです。たとえば、`RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL` は、ライブラリのシンボルが他の共有ライブラリで使用できるようにし、共有ライブラリ間の依存関係がある状況に対処します。

ライブラリが見つからない場合、このメソッドはエラーをスローします。ただし、キーワード引数 `throw_error` が `false` に設定されている場合、このメソッドは `nothing` を返します。

!!! note
    Julia 1.6 以降、このメソッドは `@executable_path/` で始まるパスを Julia 実行可能ファイルへのパスに置き換え、再配置可能な相対パスのロードを可能にします。Julia 1.5 およびそれ以前では、これは macOS でのみ機能しました。

