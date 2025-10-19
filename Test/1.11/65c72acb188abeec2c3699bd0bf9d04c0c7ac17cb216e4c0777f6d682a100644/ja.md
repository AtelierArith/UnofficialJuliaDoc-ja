"     get*test*counts(::AbstractTestSet) -> TestCounts

テストセット内の各タイプのテスト結果の数を直接カウントし、子テストセット全体の合計を計算する再帰関数です。

カスタム `AbstractTestSet` は、この関数を実装して、合計をカウントし、`DefaultTestSet` とともに表示する必要があります。

カスタム `TestSet` に対してこれが実装されていない場合、印刷は失敗に対して `x` を報告し、所要時間に対して `?s` にフォールバックします。
