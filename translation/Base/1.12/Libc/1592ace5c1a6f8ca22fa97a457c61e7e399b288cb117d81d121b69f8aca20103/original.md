```julia
dup(src::RawFD[, target::RawFD])::RawFD
```

Duplicate the file descriptor `src` so that the duplicate refers to the same OS resource (e.g. a file or socket). A `target` file descriptor may be optionally be passed to use for the new duplicate.
