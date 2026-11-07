```julia
detect_archive_format(tarball_path::AbstractString)
```

Detect compression format by reading file magic bytes. Returns one of: "zstd", "gzip", "bzip2", "xz", "lz4", "tar", or "unknown".

Note: This is used both for determining file extensions after download and for selecting the appropriate decompression tool.
