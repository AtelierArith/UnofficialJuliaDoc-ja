```
LibGit2.DiffDelta
```

Description of changes to one entry. Matches the [`git_diff_delta`](https://libgit2.org/libgit2/#HEAD/type/git_diff_delta) struct.

The fields represent:

  * `status`: One of `Consts.DELTA_STATUS`, indicating whether the file has been added/modified/deleted.
  * `flags`: Flags for the delta and the objects on each side. Determines whether to treat the file(s)  as binary/text, whether they exist on each side of the diff, and whether the object ids are known  to be correct.
  * `similarity`: Used to indicate if a file has been renamed or copied.
  * `nfiles`: The number of files in the delta (for instance, if the delta  was run on a submodule commit id, it may contain more than one file).
  * `old_file`: A [`DiffFile`](@ref) containing information about the file(s) before the changes.
  * `new_file`: A [`DiffFile`](@ref) containing information about the file(s) after the changes.
