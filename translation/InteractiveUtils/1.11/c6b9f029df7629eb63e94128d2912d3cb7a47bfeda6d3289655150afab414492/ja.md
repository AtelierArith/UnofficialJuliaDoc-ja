```julia
code_native([io=stdout,], f, types; syntax=:intel, debuginfo=:default, binary=false, dump_module=true)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドを実行するために生成されたネイティブアセンブリ命令を`io`に出力します。

  * `syntax`を`:intel`（デフォルト）に設定するとインテル構文、`:att`に設定するとAT&T構文のアセンブリ構文を設定できます。
  * `debuginfo`を`:source`（デフォルト）または`:none`に設定することで、コードコメントの冗長性を指定できます。
  * `binary`が`true`の場合、各命令の前に省略されたアドレスを付けてバイナリ機械コードも出力します。
  * `dump_module`が`false`の場合、rodataやディレクティブなどのメタデータは出力しません。
  * `raw`が`false`の場合、興味のない命令（セーフポイント関数のプロローグなど）は省略されます。

参照: [`@code_native`](@ref), [`code_warntype`](@ref), [`code_typed`](@ref), [`code_lowered`](@ref), [`code_llvm`](@ref)。
