```julia
GitHash(ref::GitReference)
```

直接参照 `ref` が指すオブジェクトの識別子（`GitHash`）を取得します。注：シンボリック参照では機能しません。その場合は、代わりに `GitHash(repo::GitRepo, ref_name::AbstractString)` を使用してください。
