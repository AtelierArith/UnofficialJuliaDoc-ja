```julia
SOURCE_MODE_NOT_REQUIRED
```

Indicates to inference that the source is not required and the only fields of the resulting `CodeInstance` that the caller is interested in are return or exception types and IPO effects. Inference is still free to create source for it or add it to the JIT even, but is not required or expected to do so.
