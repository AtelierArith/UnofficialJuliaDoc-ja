```
content(blob::GitBlob) -> String
```

Fetch the contents of the [`GitBlob`](@ref) `blob`. If the `blob` contains binary data (which can be determined using [`isbinary`](@ref)), throw an error. Otherwise, return a `String` containing the contents of the `blob`.
