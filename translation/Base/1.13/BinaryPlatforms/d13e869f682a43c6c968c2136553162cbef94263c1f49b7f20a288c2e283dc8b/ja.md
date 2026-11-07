```julia
libgfortran_version(p::AbstractPlatform)
```

この `Platform` オブジェクトによって指定される libgfortran のバージョンを `VersionNumber` として取得します。互換性の上限が設定されていない場合は、`nothing` として取得します。
