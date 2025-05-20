```
ConsoleLogger([stream,] min_level=Info; meta_formatter=default_metafmt,
              show_limited=true, right_justify=0)
```

テキストコンソールでの可読性に最適化されたフォーマットのロガーで、例えばJulia REPLでのインタラクティブな作業に使用されます。

`min_level`未満のログレベルはフィルタリングされます。

メッセージのフォーマットはキーワード引数を設定することで制御できます：

  * `meta_formatter`は、ログイベントのメタデータ`(level, _module, group, id, file, line)`を受け取り、ログメッセージのための色（printstyledに渡されるもの）とプレフィックスおよびサフィックスを返す関数です。デフォルトは、ログレベルでプレフィックスを付け、モジュール、ファイル、行位置を含むサフィックスを付けることです。
  * `show_limited`は、大きなデータ構造の印刷を画面に収まるものに制限し、フォーマット中に`:limit` `IOContext`キーを設定します。
  * `right_justify`は、ログメタデータが右揃えされる整数列です。デフォルトはゼロ（メタデータは独自の行に配置されます）です。
