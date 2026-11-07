```julia
Sys.CPU_NAME::String
```

A string representing the name of CPU.

# Examples

For example, `Sys.CPU_NAME` might equal `"tigerlake"` on an [Intel Core "Tiger Lake" CPU](https://en.wikipedia.org/wiki/Tiger_Lake), or `"apple-m1"` on an [Apple M1 CPU](https://en.wikipedia.org/wiki/Apple_M1).

Note: Included in the detailed system information via `versioninfo(verbose=true)`.
