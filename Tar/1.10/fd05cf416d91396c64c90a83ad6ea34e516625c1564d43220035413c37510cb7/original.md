```
list(tarball; [ strict = true ]) -> Vector{Header}
list(callback, tarball; [ strict = true ])

    callback  :: Header, [ <data> ] --> Any
    tarball   :: Union{AbstractString, AbstractCmd, IO}
    strict    :: Bool
```

List the contents of a tar archive ("tarball") located at the path `tarball`. If `tarball` is an IO handle, read the tar contents from that stream. Returns a vector of `Header` structs. See [`Header`](@ref) for details.

If a `callback` is provided then instead of returning a vector of headers, the callback is called on each `Header`. This can be useful if the number of items in the tarball is large or if you want examine items prior to an error in the tarball. If the `callback` function can accept a second argument of either type `Vector{UInt8}` or `Vector{Pair{Symbol, String}}` then it will be called with a representation of the raw header data either as a single byte vector or as a vector of pairs mapping field names to the raw data for that field (if these fields are concatenated together, the result is the raw data of the header).

By default `list` will error if it encounters any tarball contents which the `extract` function would refuse to extract. With `strict=false` it will skip these checks and list all the the contents of the tar file whether `extract` would extract them or not. Beware that malicious tarballs can do all sorts of crafty and unexpected things to try to trick you into doing something bad.

If the `tarball` argument is a skeleton file (see `extract` and `create`) then `list` will detect that from the file header and appropriately list or iterate the headers of the skeleton file.
