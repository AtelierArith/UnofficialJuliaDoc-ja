```julia
findall(sig::Type, view::MethodTableView; limit::Int=-1) ->
    matches::MethodLookupResult or nothing
```

与えられたメソッドテーブル `view` において、与えられたシグネチャ `sig` に適用可能なすべてのメソッドを見つけます。適用可能なメソッドが見つからない場合、空の結果が返されます。適用可能なメソッドの数が指定された `limit` を超えた場合、`nothing` が返されます。デフォルト設定 `limit=-1` は適用可能なメソッドの数を制限しません。`overlayed` は、一致するメソッドのいずれかがオーバーレイされたメソッドテーブルから来ているかどうかを示します。
