```julia
ConsoleLogger([stream,] min_level=Info; meta_formatter=default_metafmt,
              show_limited=true, right_justify=0)
```

Julia REPLでの対話的な作業など、テキストコンソールでの読みやすさを重視して最適化されたロガーです。

`min_level` 未満のログレベルはフィルタリングされます。

このロガーはスレッドセーフです。メッセージ数の制限（`maxlog`）の管理と、ストリームへの書き込みの両方でロックを使用します。

キーワード引数を設定すると、メッセージの書式を制御できます。

  * `meta_formatter` は、ログイベントのメタデータ `(level, _module, group, id, file, line)` を受け取り、ログメッセージの色（printstyled に渡す値）、プレフィックス、サフィックスを返す関数です。デフォルトでは、ログレベルをプレフィックスにし、モジュール、ファイル、行の位置情報をサフィックスにします。
  * `show_limited` は、書式設定時に `:limit` `IOContext` キーを設定することで、大きなデータ構造の出力を画面に収まる程度に制限します。
  * `right_justify` は、ログメタデータを右揃えで表示する列番号を指定する整数です。デフォルトは 0 で、この場合メタデータは独立した行に表示されます。
