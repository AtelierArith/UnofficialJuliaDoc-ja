```julia
select_platform(download_info::Dict, platform::AbstractPlatform = HostPlatform())
```

Given a `download_info` dictionary mapping platforms to some value, choose the value whose key best matches `platform`, returning `nothing` if no matches can be found.

Platform attributes such as architecture, libc, calling ABI, etc... must all match exactly, however attributes such as compiler ABI can have wildcards within them such as `nothing` which matches any version of GCC.
