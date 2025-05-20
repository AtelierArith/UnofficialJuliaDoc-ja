```
Pkg.respect_sysimage_versions(b::Bool=true)
```

sysimageにあるバージョンを尊重するかどうかを有効にします（`b=true`）または無効にします（`b=false`）（デフォルトでは有効）。

このオプションが有効になっている場合、Pkgはsysimageに入れられたパッケージ（例：PackageCompilerを介して）を、sysimage内のパッケージのバージョンでのみインストールします。また、sysimageにあるパッケージをURLで追加したり、`develop`したりしようとするとエラーになります。
