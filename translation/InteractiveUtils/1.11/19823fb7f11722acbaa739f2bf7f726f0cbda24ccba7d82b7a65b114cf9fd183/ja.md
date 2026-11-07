```julia
code_llvm([io=stdout,], f, types; raw=false, dump_module=false, optimize=true, debuginfo=:default)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドを実行するために生成された LLVM ビットコードを、`io` に出力します。

`optimize` キーワードが設定されていない場合、LLVM の最適化前のコードが表示されます。出力されるビットコードからは、すべてのメタデータと dbg.* 呼び出しが削除されます。完全な IR を表示するには、`raw` キーワードを true に設定します。関数を含むモジュール全体（宣言を含む）をダンプするには、`dump_module` キーワードを true に設定します。キーワード引数 `debuginfo` には、コードコメントの詳細度を指定するため、source（デフォルト）または none を指定できます。

関連項目: [`@code_llvm`](@ref)、[`code_warntype`](@ref)、[`code_typed`](@ref)、[`code_lowered`](@ref)、[`code_native`](@ref)。
