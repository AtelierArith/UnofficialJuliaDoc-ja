```julia
Base.identify_package_env(name::String)::Union{Tuple{PkgId, String}, Nothing}
Base.identify_package_env(where::Union{Module,PkgId}, name::String)::Union{Tuple{PkgId, Union{String, Nothing}}, Nothing}
```

Same as [`Base.identify_package`](@ref) except that the path to the environment where the package is identified is also returned, except when the identity is not identified.
