```julia
code_native([io=stdout,], f, types; syntax=:intel, debuginfo=:default, binary=false, dump_module=true, raw=false)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドを実行するために生成された、ネイティブのアセンブリ命令を `io` に出力します。

  * `syntax` を `:intel`（デフォルト）に設定すると Intel 構文に、`:att` に設定すると AT&T 構文になります。
  * `debuginfo` を `:source`（`:default` と同等）または `:none` に設定して、コードコメントの詳細度を指定します。
  * `binary` が `true` の場合、各命令のバイナリマシンコードも、短縮アドレスを先頭に付けて出力します。
  * `dump_module` が `false` の場合、rodata やディレクティブなどのメタデータは出力しません。
  * `raw` が `false`（デフォルト）の場合、セーフポイント関数のプロローグなど、重要でない命令は省略されます。

関連項目: [`@code_native`](@ref)、[`code_warntype`](@ref)、[`code_typed`](@ref)、[`code_lowered`](@ref)、[`code_llvm`](@ref)。
