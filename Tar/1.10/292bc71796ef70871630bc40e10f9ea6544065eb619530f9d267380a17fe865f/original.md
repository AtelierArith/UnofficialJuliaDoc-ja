The `Header` type is a struct representing the essential metadata for a single record in a tar file with this definition:

```julia
struct Header
    path :: String # path relative to the root
    type :: Symbol # type indicator (see below)
    mode :: UInt16 # mode/permissions (best viewed in octal)
    size :: Int64  # size of record data in bytes
    link :: String # target path of a symlink
end
```

Types are represented with the following symbols: `file`, `hardlink`, `symlink`, `chardev`, `blockdev`, `directory`, `fifo`, or for unknown types, the typeflag character as a symbol. Note that [`extract`](@ref) refuses to extract records types other than `file`, `symlink` and `directory`; [`list`](@ref) will only list other kinds of records if called with `strict=false`.

The tar format includes various other metadata about records, including user and group IDs, user and group names, and timestamps. The `Tar` package, by design, completely ignores these. When creating tar files, these fields are always set to zero/empty. When reading tar files, these fields are ignored aside from verifying header checksums for each header record for all fields.
