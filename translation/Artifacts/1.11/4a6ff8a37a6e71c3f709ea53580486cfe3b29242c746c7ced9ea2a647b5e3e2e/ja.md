```julia
artifact_path(hash::SHA1; honor_overrides::Bool=true)
```

SHA1 Gitツリーハッシュで識別されるアーティファクトを指定すると、そのインストール先のパスを返します。アーティファクトが存在しない場合は、インストールされる予定の場所を返します。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

