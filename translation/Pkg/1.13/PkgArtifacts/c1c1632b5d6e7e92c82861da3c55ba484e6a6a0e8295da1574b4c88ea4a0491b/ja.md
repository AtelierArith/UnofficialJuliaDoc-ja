```julia
extract_all_hashes(artifacts_toml::String;
                    platform = HostPlatform(),
                    pkg_uuid = nothing,
                    include_lazy = false)
```

指定した`(Julia)Artifacts.toml`ファイルからすべてのハッシュを抽出します。デポ内の`Overrides.toml`エントリによるオーバーライドを適切にサポートするには、`package_uuid`を指定する必要があります。

`include_lazy`を`true`に設定すると、遅延パッケージもインストールされます。
