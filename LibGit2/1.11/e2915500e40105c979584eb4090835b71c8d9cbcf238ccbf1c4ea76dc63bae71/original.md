```
GitHash(ptr::Ptr{UInt8})
```

Construct a `GitHash` from a pointer to `UInt8` data containing the bytes of the SHA-1 hash. The constructor throws an error if the pointer is null, i.e. equal to `C_NULL`.
