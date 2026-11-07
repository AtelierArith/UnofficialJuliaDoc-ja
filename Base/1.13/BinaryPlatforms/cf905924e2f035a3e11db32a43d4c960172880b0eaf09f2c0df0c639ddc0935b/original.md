```julia
detect_libstdcxx_version(max_minor_version::Int=30)
```

Inspects the currently running Julia process to find out what version of libstdc++ it is linked against (if any).  `max_minor_version` is the latest version in the 3.4 series of GLIBCXX where the search is performed.
