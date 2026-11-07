```julia
Pkg.Apps.develop(pkg::Union{String, PackageSpec})
Pkg.Apps.develop(; name, uuid, version, url, rev, path, subdir)
```

[`Pkg.Apps.add`](@ref)と似ていますが、アプリは開発中のプロジェクトから直接実行されるため、プロジェクトへの変更がすぐにアプリに反映されます。

# Examples

```julia
Pkg.Apps.develop("Runic")
Pkg.Apps.develop(path = "path/to/Package")
```
