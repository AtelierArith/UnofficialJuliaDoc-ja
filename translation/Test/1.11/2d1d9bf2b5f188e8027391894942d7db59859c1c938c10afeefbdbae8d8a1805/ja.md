```julia
TestCounts
```

テストセットの結果を表示するために、結果を再帰的に収集する際の状態を保持します。

フィールド:

  * `customized`: このカウント対象の `AbstractTestSet` に対して、関数 `get_test_counts` がカスタマイズされているかどうか。カスタムメソッドを定義した場合は、必ず `true` をコンストラクターに渡してください。
  * `passes`: 成功した `@test` の呼び出し回数。
  * `fails`: 失敗した `@test` の呼び出し回数。
  * `errors`: エラーが発生した `@test` の呼び出し回数。
  * `broken`: 破損した `@test` の呼び出し回数。
  * `passes`: 成功した `@test` の累積呼び出し回数。
  * `fails`: 失敗した `@test` の累積呼び出し回数。
  * `errors`: エラーが発生した `@test` の累積呼び出し回数。
  * `broken`: 破損した `@test` の累積呼び出し回数。
  * `duration`: 対象の `AbstractTestSet` の実行時間の合計を、書式化された `String` として表したもの。
