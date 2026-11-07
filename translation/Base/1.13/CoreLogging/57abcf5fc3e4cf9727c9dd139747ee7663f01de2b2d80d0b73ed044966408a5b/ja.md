```julia
ConsoleLogger([stream,] min_level=Info; meta_formatter=default_metafmt,
              show_limited=true, right_justify=0)
```

Julia REPLでの対話的な作業など、テキストコンソールでの読みやすさを重視したロガーです。

`min_level` 未満のログレベルは出力されません。

このロガーはスレッドセーフです。メッセージ数の制限（`maxlog`）の管理と、ストリームへの書き込みの両方にロックを使用します。

キーワード引数を設定すると、メッセージの書式を制御できます。

  * `meta_formatter` は、ログイベントのメタデータ `(level, _module, group, id, file, line)` を受け取り、ログメッセージの色（printstyled に渡す値と同様）、プレフィックス、サフィックスを返す関数です。デフォルトでは、ログレベルをプレフィックスにし、モジュール、ファイル、行の位置情報をサフィックスにします。
  * `show_limited` を指定すると、書式設定時に `:limit` `IOContext` キーを設定し、大きなデータ構造の出力を画面に収まる程度に制限できます。
  * `right_justify` は、ログのメタデータを右揃えで表示する列番号を整数で指定します。デフォルトは 0 で、この場合メタデータは独立した行に表示されます。
