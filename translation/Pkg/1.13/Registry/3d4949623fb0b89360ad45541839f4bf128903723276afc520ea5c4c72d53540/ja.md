```julia
is_pkg_in_pkgserver_registry(pkg_uuid::Base.UUID, server_registry_info, registries)
```

パッケージの UUID が PkgServer によって追跡されているかどうかを、PkgServer が認識しているレジストリにその UUID が存在するか確認して判定します。
