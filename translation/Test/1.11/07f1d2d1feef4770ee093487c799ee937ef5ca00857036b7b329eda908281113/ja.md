```julia
finish(ts::AbstractTestSet)
```

与えられたテストセットに必要な最終処理を行います。これは、テストブロックが実行された後に `@testset` インフラストラクチャによって呼び出されます。

カスタム `AbstractTestSet` サブタイプは、テスト結果のツリーに自分自身を追加するために、親（もしあれば）の `record` を呼び出す必要があります。これは次のように実装されるかもしれません：

```julia
if get_testset_depth() != 0
    # このテストセットを親テストセットに添付する
    parent_ts = get_testset()
    record(parent_ts, self)
    return self
end
```
