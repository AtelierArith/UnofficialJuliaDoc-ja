```julia
ensure_artifact_installed(name::String, artifacts_toml::String;
                            platform::AbstractPlatform = HostPlatform(),
                            pkg_uuid::Union{Base.UUID,Nothing}=nothing,
                            verbose::Bool = false,
                            quiet_download::Bool = false,
                            io::IO=stderr)
```

Ensures an artifact is installed, downloading it via the download information stored in `artifacts_toml` if necessary.  Throws an error if unable to install.
