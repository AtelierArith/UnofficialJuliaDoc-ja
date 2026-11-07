```julia
Pkg.respect_sysimage_versions(b::Bool=true)
```

sysimage 内のバージョンを尊重する機能を有効化（`b=true`）または無効化（`b=false`）します（デフォルトでは有効）。

このオプションを有効にすると、Pkg は sysimage に含まれているパッケージ（たとえば PackageCompiler 経由で追加されたもの）を、sysimage 内のバージョンでのみインストールします。また、sysimage に含まれているパッケージを URL から追加したり、`develop` したりしようとすると、エラーになります。
