```julia
@code_native
```

関数またはマクロ呼び出しの引数を評価して型を判定し、その結果の式に対して[`code_native`](@ref)を呼び出します。

省略可能なキーワード引数`syntax`、`debuginfo`、`binary`、`dump_module`のいずれかを設定するには、次のように関数呼び出しの前に指定します。

```julia
@code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)
```

  * アセンブリ構文を指定するには、`syntax`を設定します。`:intel`（デフォルト）はIntel構文、`:att`はAT&T構文です。
  * コードコメントの詳細度を指定するには、`debuginfo`を`:source`（デフォルト）または`:none`に設定します。
  * `binary`が`true`の場合、各命令のバイナリ機械語コードも、短縮アドレスを先頭に付けて出力します。
  * `dump_module`が`false`の場合、rodataやディレクティブなどのメタデータは出力しません。

関連項目：[`code_native`](@ref)、[`@code_warntype`](@ref)、[`@code_typed`](@ref)、[`@code_lowered`](@ref)、[`@code_llvm`](@ref)。
