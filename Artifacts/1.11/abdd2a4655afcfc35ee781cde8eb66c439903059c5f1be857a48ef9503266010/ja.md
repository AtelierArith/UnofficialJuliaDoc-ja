```
artifact_meta(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform(),
              pkg_uuid::Union{Base.UUID,Nothing}=nothing)
```

指定されたアーティファクト（名前で識別される）に関するメタデータを、指定された `(Julia)Artifacts.toml` ファイル内から取得します。アーティファクトがプラットフォーム固有の場合は、`platform` を使用して最も適切なマッピングを選択します。見つからない場合は `nothing` を返します。

!!! compat "Julia 1.3"
    この関数は少なくとも Julia 1.3 を必要とします。

