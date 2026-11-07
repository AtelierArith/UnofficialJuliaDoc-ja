```julia
finish(ts::AbstractTestSet)
```

指定されたテストセットに必要な最終処理を行います。テストブロックの実行後、`@testset` インフラストラクチャによって呼び出されます。

カスタムの `AbstractTestSet` サブタイプは、テスト結果のツリーに自身を追加するため、親が存在する場合はその親に対して `record` を呼び出す必要があります。これは次のように実装できます。

```julia
if get_testset_depth() != 0
    # Attach this test set to the parent test set
    parent_ts = get_testset()
    record(parent_ts, self)
    return self
end
```
