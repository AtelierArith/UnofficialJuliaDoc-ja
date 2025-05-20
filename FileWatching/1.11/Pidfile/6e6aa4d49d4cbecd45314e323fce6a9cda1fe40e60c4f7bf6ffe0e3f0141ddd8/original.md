```
tryopen_exclusive(path::String, mode::Integer = 0o444) :: Union{Void, File}
```

Try to create a new file for read-write advisory-exclusive access, return nothing if it already exists.
