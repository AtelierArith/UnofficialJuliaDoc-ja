```julia
Base.identify_package_env(name::String)::Union{Tuple{PkgId, String}, Nothing}
Base.identify_package_env(where::Union{Module,PkgId}, name::String)::Union{Tuple{PkgId, Union{String, Nothing}}, Nothing}
```

[`Base.identify_package`](@ref)と同じですが、パッケージが特定された環境へのパスも返します。ただし、パッケージが特定されなかった場合は返しません。
