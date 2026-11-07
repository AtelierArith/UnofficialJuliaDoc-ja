```julia
canonicalize_typeassert!(compact::IncrementalCompact, idx::Int, stmt::Expr)
```

後続の解析で後者の形式だけを扱えば済むように、`X = typeassert(Y, T)::S` を `typeassert(Y, T); X = π(Y, S)` に正規化します。

注：推論では、`S` の型を単なる `T` よりも正確に特定できる場合があります。しかし、ここから先はそれを使うだけで問題ありません。バックエンドの実装を簡単にするため、値を返さないように定義された `typeassert` のバージョンを用意したほうがよさそうです。
