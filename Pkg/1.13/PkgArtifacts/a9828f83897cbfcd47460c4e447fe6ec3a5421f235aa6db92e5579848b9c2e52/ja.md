```julia
ensure_all_artifacts_installed(artifacts_toml::String;
                                platform = HostPlatform(),
                                pkg_uuid = nothing,
                                include_lazy = false,
                                verbose = false,
                                quiet_download = false,
                                io::IO=stderr)
```

指定された`(Julia)Artifacts.toml`ファイルに含まれる、遅延読み込みではないすべてのアーティファクトをインストールします。デポ内の`Overrides.toml`エントリによるオーバーライドを適切にサポートするには、`package_uuid`を指定する必要があります。

`include_lazy`が`true`に設定されている場合は、遅延読み込みのパッケージもインストールされます。

この関数は非推奨です。次のスニペットに置き換えてください。

```julia
artifacts = select_downloadable_artifacts(artifacts_toml; platform, include_lazy)
for name in keys(artifacts)
    ensure_artifact_installed(name, artifacts[name], artifacts_toml; platform=platform)
end
```

!!! warning
    この関数はJulia 1.6で非推奨となり、将来のバージョンで削除される予定です。代わりに`select_downloadable_artifacts()`と`ensure_artifact_installed()`を使用してください。

