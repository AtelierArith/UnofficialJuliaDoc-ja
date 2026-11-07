```julia
transact(f::Function, repo::GitRepo)
```

git リポジトリ `repo` に関数 `f` を適用します。`f` を適用する前に、[`snapshot`](@ref) を取得します。`f` 内でエラーが発生した場合、[`restore`](@ref) を使用して `repo` をスナップショットの状態に戻します。発生したエラーは再スローされますが、`repo` の状態は破損しません。
