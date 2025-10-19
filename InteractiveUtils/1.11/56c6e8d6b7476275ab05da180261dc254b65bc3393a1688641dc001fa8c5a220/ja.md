```julia
code_llvm([io=stdout,], f, types; raw=false, dump_module=false, optimize=true, debuginfo=:default)
```

指定されたジェネリック関数と型シグネチャに対して実行されるメソッドに対して生成されたLLVMビットコードを`io`に出力します。

`optimize`キーワードが設定されていない場合、コードはLLVM最適化の前に表示されます。すべてのメタデータとdbg.*呼び出しは印刷されたビットコードから削除されます。完全なIRを表示するには、`raw`キーワードをtrueに設定します。関数をカプセル化するモジュール全体（宣言を含む）をダンプするには、`dump_module`キーワードをtrueに設定します。キーワード引数`debuginfo`は、ソース（デフォルト）またはなしのいずれかで、コードコメントの冗長性を指定します。

参照: [`@code_llvm`](@ref), [`code_warntype`](@ref), [`code_typed`](@ref), [`code_lowered`](@ref), [`code_native`](@ref)。
