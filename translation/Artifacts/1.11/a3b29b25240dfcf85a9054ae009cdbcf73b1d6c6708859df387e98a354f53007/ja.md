```julia
artifact_meta(name::String, artifacts_toml::String;
              platform::AbstractPlatform = HostPlatform(),
              pkg_uuid::Union{Base.UUID,Nothing}=nothing)
```

指定された `(Julia)Artifacts.toml` ファイルに格納されている、名前で識別されるアーティファクトのメタデータを取得します。アーティファクトがプラットフォーム固有の場合は、最適なマッピングを選択するために `platform` を使用します。該当するものが見つからない場合は、`nothing` を返します。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

