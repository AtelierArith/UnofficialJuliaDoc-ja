```julia
os_version(p::AbstractPlatform)
```

Get the OS version dictated by this `Platform` object, or `nothing` if no OS version is imposed/no data is available.  This is most commonly used by MacOS and FreeBSD objects where we have high platform SDK fragmentation, and features are available only on certain platform versions.
