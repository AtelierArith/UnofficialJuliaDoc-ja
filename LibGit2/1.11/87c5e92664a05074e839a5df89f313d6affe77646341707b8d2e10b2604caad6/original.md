```
rawcontent(blob::GitBlob) -> Vector{UInt8}
```

Fetch the *raw* contents of the [`GitBlob`](@ref) `blob`. This is an `Array` containing the contents of the blob, which may be binary or may be Unicode. If you write to this `Array` the blob on disk will not be updated. `rawcontent` will allow the user to load the raw binary data into the output `Array` and will not check to ensure it is valid Unicode, so errors may occur if the result is passed to functions which expect valid Unicode data.

See also [`content`](@ref), which *will* throw an error if the content of the `blob` is binary and not valid Unicode.
