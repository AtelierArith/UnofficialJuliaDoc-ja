```julia
Sys.windows_version()
```

Windows NT カーネルのバージョン番号を `VersionNumber` として返します。つまり、`v"major.minor.build"` です。Windows 上で実行されていない場合は、`v"0.0.0"` を返します。
