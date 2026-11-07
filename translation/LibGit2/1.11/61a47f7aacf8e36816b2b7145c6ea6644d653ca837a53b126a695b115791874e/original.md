```julia
LibGit2.StatusOptions
```

Options to control how `git_status_foreach_ext()` will issue callbacks. Matches the [`git_status_opt_t`](https://libgit2.org/libgit2/#HEAD/type/git_status_opt_t) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `show`: a flag for which files to examine and in which order. The default is `Consts.STATUS_SHOW_INDEX_AND_WORKDIR`.
  * `flags`: flags for controlling any callbacks used in a status call.
  * `pathspec`: an array of paths to use for path-matching. The behavior of the path-matching will vary depending on the values of `show` and `flags`.
  * The `baseline` is the tree to be used for comparison to the working directory and index; defaults to HEAD.
