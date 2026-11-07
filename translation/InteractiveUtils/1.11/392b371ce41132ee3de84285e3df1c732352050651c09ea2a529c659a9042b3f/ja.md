```julia
@code_native
```

関数またはマクロ呼び出しの引数を評価して型を判定し、その結果の式に対して[`code_native`](@ref)を呼び出します。

省略可能なキーワード引数`syntax`、`debuginfo`、`binary`、`dump_module`のいずれかを設定するには、次のように関数呼び出しの前に指定します。

```julia
@code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)
```

  * アセンブリ構文を指定するには、`syntax`に、Intel構文の場合は`:intel`（デフォルト）、AT&T構文の場合は`:att`を設定します。
  * コードコメントの詳細度を指定するには、`debuginfo`に`:source`（デフォルト）または`:none`を設定します。
  * `binary`が`true`の場合、各命令のバイナリマシンコードも、短縮アドレスを先頭に付けて出力します。
  * `dump_module`が`false`の場合、rodataやディレクティブなどのメタデータは出力しません。

関連項目: [`code_native`](@ref)、[`@code_warntype`](@ref)、[`@code_typed`](@ref)、[`@code_lowered`](@ref)、[`@code_llvm`](@ref)。
