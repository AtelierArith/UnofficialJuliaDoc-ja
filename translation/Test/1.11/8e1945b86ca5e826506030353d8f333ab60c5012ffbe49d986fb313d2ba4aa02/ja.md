```julia
TestCounts
```

テストセットの結果を再帰的に収集するための状態を保持します。

フィールド:

  * `customized`: `get_test_counts` 関数がこのカウントオブジェクトのために `AbstractTestSet` に対してカスタマイズされたかどうか。カスタムメソッドが定義されている場合は、常にコンストラクタに `true` を渡してください。
  * `passes`: 合格した `@test` の呼び出しの数。
  * `fails`: 不合格の `@test` の呼び出しの数。
  * `errors`: エラーのある `@test` の呼び出しの数。
  * `broken`: 壊れた `@test` の呼び出しの数。
  * `passes`: 合格した `@test` の呼び出しの累積数。
  * `fails`: 不合格の `@test` の呼び出しの累積数。
  * `errors`: エラーのある `@test` の呼び出しの累積数。
  * `broken`: 壊れた `@test` の呼び出しの累積数。
  * `duration`: 該当する `AbstractTestSet` が実行された合計時間をフォーマットされた `String` として。
