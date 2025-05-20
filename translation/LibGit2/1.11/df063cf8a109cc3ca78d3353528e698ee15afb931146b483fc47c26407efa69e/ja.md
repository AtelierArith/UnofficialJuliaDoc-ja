```
GitHash(ref::GitReference)
```

直接参照 `ref` によって参照されるオブジェクトの識別子 (`GitHash`) を取得します。注意: これはシンボリック参照には機能しません。その場合は、代わりに `GitHash(repo::GitRepo, ref_name::AbstractString)` を使用してください。
