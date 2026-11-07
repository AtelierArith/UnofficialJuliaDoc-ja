```julia
libgfortran_version(p::AbstractPlatform)
```

Get the libgfortran version dictated by this `Platform` object as a `VersionNumber`, or `nothing` if no compatibility bound is imposed.
