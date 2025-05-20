```
artifact_hash(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform())
```

指定されたプラットフォームで圧縮されたアーティファクトのハッシュを返すための `artifact_meta()` の薄いラッパー。マッピングが見つからない場合は `nothing` を返します。

!!! compat "Julia 1.3"
    この関数は少なくとも Julia 1.3 を必要とします。

