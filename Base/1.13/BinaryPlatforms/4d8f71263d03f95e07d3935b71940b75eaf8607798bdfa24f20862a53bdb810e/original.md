```julia
HostPlatform()
```

Return the `Platform` object that corresponds to the current host system, with all relevant comparison strategies set to host platform mode.  This is equivalent to:

```julia
HostPlatform(parse(Platform, Base.BinaryPlatforms.host_triplet()))
```
