```julia
platform_key_abi(machine::AbstractString)
```

Returns the platform key for the current platform, or any other though the the use of the `machine` parameter.

This method is deprecated, import `Base.BinaryPlatforms` and use either `HostPlatform()` to get the current host platform, or `parse(Base.BinaryPlatforms.Platform, triplet)` to parse the triplet for some other platform instead.
