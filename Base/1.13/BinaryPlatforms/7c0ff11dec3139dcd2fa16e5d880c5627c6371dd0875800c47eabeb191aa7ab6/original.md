```julia
HostPlatform(p::AbstractPlatform)
```

Convert a `Platform` to act like a "host"; e.g. if it has a version-bound tag such as `"libstdcxx_version" => "3.4.26"`, it will treat that value as an upper bound, rather than a characteristic.  `Platform` objects that define artifacts generally denote the SDK or version that the artifact was built with, but for platforms, these versions are generally the maximal version the platform can support.  The way this transformation is implemented is to change the appropriate comparison strategies to treat these pieces of data as bounds rather than points in any comparison.
