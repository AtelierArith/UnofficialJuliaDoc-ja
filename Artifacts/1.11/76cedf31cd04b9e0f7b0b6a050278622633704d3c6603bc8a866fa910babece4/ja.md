```julia
artifact_exists(hash::SHA1; honor_overrides::Bool=true)
```

指定されたアーティファクト（sha1 の Git ツリーハッシュで識別）がディスク上に存在するかどうかを返します。指定されたアーティファクトが複数の場所（複数のデポ内など）に存在する場合もあります。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

