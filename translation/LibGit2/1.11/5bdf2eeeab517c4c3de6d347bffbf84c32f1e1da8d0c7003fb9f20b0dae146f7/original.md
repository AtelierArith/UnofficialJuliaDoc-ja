```julia
LibGit2.DiffFile
```

Description of one side of a delta. Matches the [`git_diff_file`](https://libgit2.org/libgit2/#HEAD/type/git_diff_file) struct.

The fields represent:

  * `id`: the [`GitHash`](@ref) of the item in the diff. If the item is empty on this  side of the diff (for instance, if the diff is of the removal of a file), this will  be `GitHash(0)`.
  * `path`: a `NULL` terminated path to the item relative to the working directory of the repository.
  * `size`: the size of the item in bytes.
  * `flags`: a combination of the [`git_diff_flag_t`](https://libgit2.org/libgit2/#HEAD/type/git_diff_flag_t)  flags. The `i`th bit of this integer sets the `i`th flag.
  * `mode`: the [`stat`](@ref) mode for the item.
  * `id_abbrev`: only present in LibGit2 versions newer than or equal to `0.25.0`.  The length of the `id` field when converted using [`string`](@ref). Usually equal to `OID_HEXSZ` (40).
