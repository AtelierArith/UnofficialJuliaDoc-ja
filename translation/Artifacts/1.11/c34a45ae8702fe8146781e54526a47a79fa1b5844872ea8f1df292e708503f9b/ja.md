```julia
artifact_hash(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform())
```

指定されたプラットフォームに対応するアーティファクトのハッシュを返すための `artifact_meta()` の薄いラッパーです。マッピングが見つからない場合は `nothing` を返します。

!!! compat "Julia 1.3"
    この関数は少なくとも Julia 1.3 が必要です。

