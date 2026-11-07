```julia
is_pkg_in_pkgserver_registry(pkg_uuid::Base.UUID, server_registry_info, registries)
```

Check if a package UUID is tracked by the PkgServer by verifying it exists in a registry that is known to the PkgServer.
