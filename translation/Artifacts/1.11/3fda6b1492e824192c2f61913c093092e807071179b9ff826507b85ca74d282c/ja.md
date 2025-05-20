```
artifact_path(hash::SHA1; honor_overrides::Bool=true)
```

SHA1 gitツリーハッシュで識別されるアーティファクトのインストールパスを返します。アーティファクトが存在しない場合は、インストールされる場所を返します。

!!! compat "Julia 1.3"
    この関数は少なくともJulia 1.3が必要です。

