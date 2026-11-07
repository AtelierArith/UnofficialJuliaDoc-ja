```julia
TestCounts
```

テストセットの結果を表示するために、結果を再帰的に収集する際の状態を保持します。

フィールド:

  * `customized`: このカウント対象の `AbstractTestSet` に対して、関数 `get_test_counts` がカスタマイズされているかどうか。カスタムメソッドを定義した場合は、必ず `true` をコンストラクターに渡してください。
  * `passes`: 成功した `@test` 呼び出しの数。
  * `fails`: 失敗した `@test` 呼び出しの数。
  * `errors`: エラーが発生した `@test` 呼び出しの数。
  * `broken`: 破損した `@test` 呼び出しの数。
  * `passes`: 成功した `@test` 呼び出しの累計数。
  * `fails`: 失敗した `@test` 呼び出しの累計数。
  * `errors`: エラーが発生した `@test` 呼び出しの累計数。
  * `broken`: 破損した `@test` 呼び出しの累計数。
  * `duration`: 対象の `AbstractTestSet` の実行時間の合計を、書式化された `String` として表したもの。
