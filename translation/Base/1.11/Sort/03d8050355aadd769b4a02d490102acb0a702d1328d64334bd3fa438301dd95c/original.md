```
partialsort(v, k, by=identity, lt=isless, rev=false)
```

Variant of [`partialsort!`](@ref) that copies `v` before partially sorting it, thereby returning the same thing as `partialsort!` but leaving `v` unmodified.
