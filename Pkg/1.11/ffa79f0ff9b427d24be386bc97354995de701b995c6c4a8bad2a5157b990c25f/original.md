```
Pkg.offline(b::Bool=true)
```

Enable (`b=true`) or disable (`b=false`) offline mode.

In offline mode Pkg tries to do as much as possible without connecting to internet. For example, when adding a package Pkg only considers versions that are already downloaded in version resolution.

To work in offline mode across Julia sessions you can set the environment variable `JULIA_PKG_OFFLINE` to `"true"`.
