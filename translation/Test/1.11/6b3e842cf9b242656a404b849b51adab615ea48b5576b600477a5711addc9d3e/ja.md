"     get*test*counts(::AbstractTestSet)::TestCounts

テストセット内に直接含まれる各種類のテスト結果の数と、子テストセット全体の合計を再帰的に数える関数です。

カスタム `AbstractTestSet` では、この関数を実装することで、合計が `DefaultTestSet` にも表示されるようになります。

カスタム `TestSet` でこの関数が実装されていない場合、失敗数は `x`、所要時間は `?s` として報告されます。
