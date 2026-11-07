"     get*test*counts(::AbstractTestSet)::TestCounts

テストセット内に直接含まれる各種類のテスト結果の数と、子テストセット全体の合計を再帰的に数える関数です。

カスタム `AbstractTestSet` では、この関数を実装すると、合計が `DefaultTestSet` とともに表示されるようになります。

カスタム `TestSet` でこの関数が実装されていない場合、表示時には失敗数として `x`、所要時間として `?s` が報告されます。
