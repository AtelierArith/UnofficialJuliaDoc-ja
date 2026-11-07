```julia
platform_dlext(p::AbstractPlatform = HostPlatform())
```

Return the dynamic library extension for the given platform, defaulting to the currently running platform.  E.g. returns "so" for a Linux-based platform, "dll" for a Windows-based platform, etc...
