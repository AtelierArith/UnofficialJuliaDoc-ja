```julia
artifact_hash(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform())
```

指定されたプラットフォームに折りたたまれたアーティファクトのハッシュを返す、`artifact_meta()`の薄いラッパーです。対応するマッピングが見つからない場合は、`nothing`を返します。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

