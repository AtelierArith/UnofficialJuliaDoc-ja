```
transact(f::Function, repo::GitRepo)
```

関数 `f` を git リポジトリ `repo` に適用し、`f` を適用する前に [`snapshot`](@ref) を取得します。`f` 内でエラーが発生した場合、`repo` は [`restore`](@ref) を使用してスナップショット状態に戻されます。発生したエラーは再スローされますが、`repo` の状態は破損しません。
