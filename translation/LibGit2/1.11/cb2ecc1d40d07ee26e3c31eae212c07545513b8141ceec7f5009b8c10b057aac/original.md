```julia
LibGit2.BlameOptions
```

Matches the [`git_blame_options`](https://libgit2.org/libgit2/#HEAD/type/git_blame_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `flags`: one of `Consts.BLAME_NORMAL` or `Consts.BLAME_FIRST_PARENT` (the other blame flags  are not yet implemented by libgit2).
  * `min_match_characters`: the minimum number of *alphanumeric* characters which much change in a commit in order for the change to be associated with that commit. The default is 20. Only takes effect if one of the `Consts.BLAME_*_COPIES` flags are used, which libgit2 does not implement yet.
  * `newest_commit`: the [`GitHash`](@ref) of the newest commit from which to look at changes.
  * `oldest_commit`: the [`GitHash`](@ref) of the oldest commit from which to look at changes.
  * `min_line`: the first line of the file from which to starting blaming. The default is `1`.
  * `max_line`: the last line of the file to which to blame. The default is `0`, meaning the last line of the file.
