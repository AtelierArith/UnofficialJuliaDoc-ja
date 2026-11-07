```julia
ensure_artifact_installed(name::String, artifacts_toml::String;
                            platform::AbstractPlatform = HostPlatform(),
                            pkg_uuid::Union{Base.UUID,Nothing}=nothing,
                            verbose::Bool = false,
                            quiet_download::Bool = false,
                            io::IO=stderr)
```

アーティファクトがインストール済みであることを確認します。必要に応じて、`artifacts_toml` に保存されているダウンロード情報を使ってダウンロードします。インストールできない場合はエラーをスローします。
