```julia
findall(sig::Type, view::MethodTableView; limit::Int=-1) ->
    matches::MethodLookupResult or nothing
```

指定されたメソッドテーブル `view` から、指定されたシグネチャ `sig` に適用可能なメソッドをすべて検索します。該当するメソッドがない場合は、空の結果が返されます。該当するメソッドの数が指定された `limit` を超える場合は、`nothing` が返されます。デフォルト設定の `limit=-1` では、該当するメソッドの数に制限がないことに注意してください。`overlayed` は、一致したメソッドのいずれかがオーバーレイされたメソッドテーブルに由来するかどうかを示します。
