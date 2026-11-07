```julia
atomic_toml_write(path::String, data; private::Bool = false, kws...)
```

Write TOML data to a file atomically by first writing to a temporary file and then moving it into place. This prevents "teared" writes if the process is interrupted or if multiple processes write to the same file. If `private` is set the file is given `0o600` permissions.

The `kws` are passed to `TOML.print`.
