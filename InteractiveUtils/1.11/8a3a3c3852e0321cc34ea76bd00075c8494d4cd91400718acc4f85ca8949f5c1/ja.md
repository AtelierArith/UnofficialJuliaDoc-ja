```
@code_native
```

関数またはマクロ呼び出しの引数を評価し、その型を決定し、結果の式に対して[`code_native`](@ref)を呼び出します。

任意のキーワード引数`syntax`、`debuginfo`、`binary`、または`dump_module`を関数呼び出しの前に置くことで設定できます。例えば：

```
@code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)
```

  * アセンブリ構文は、`syntax`を`:intel`（デフォルト）に設定してIntel構文を使用するか、`:att`に設定してAT&T構文を使用します。
  * コードコメントの冗長性は、`debuginfo`を`:source`（デフォルト）または`:none`に設定することで指定します。
  * `binary`が`true`の場合、各命令の前に省略されたアドレスを付けてバイナリ機械コードも印刷します。
  * `dump_module`が`false`の場合、rodataやディレクティブなどのメタデータは印刷しません。

関連情報: [`code_native`](@ref)、[`@code_warntype`](@ref)、[`@code_typed`](@ref)、[`@code_lowered`](@ref)、[`@code_llvm`](@ref)。
