```julia
Pkg.respect_sysimage_versions(b::Bool=true)
```

sysimage 内のバージョンを尊重する設定を有効にする（`b=true`）か、無効にします（`b=false`）。デフォルトでは有効です。

この設定を有効にすると、Pkg は sysimage に含まれているパッケージ（たとえば PackageCompiler を使って追加したパッケージ）を、sysimage 内のバージョンでのみインストールします。また、URL を指定してパッケージを追加しようとした場合や、sysimage に含まれているパッケージを `develop` しようとした場合は、エラーになります。
