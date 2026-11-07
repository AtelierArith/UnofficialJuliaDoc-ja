```julia
struct CachedMethodTable <: MethodTableView
```

元のメソッドテーブルよりも高速に、繰り返される同一のクエリに応答できるローカルな高速パスキャッシュを追加し、別のメソッドテーブルビューに重ね合わせます。
