```julia
package(src_dir::AbstractString, tarball_path::AbstractString)
```

Compress `src_dir` into a tarball located at `tarball_path`. Supports both gzip and zstd compression based on file extension.
