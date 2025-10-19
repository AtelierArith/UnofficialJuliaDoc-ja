```julia
LibGit2.DiffOptionsStruct
```

Matches the [`git_diff_options`](https://libgit2.org/libgit2/#HEAD/type/git_diff_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `flags`: flags controlling which files will appear in the diff. Defaults to `DIFF_NORMAL`.
  * `ignore_submodules`: whether to look at files in submodules or not. Defaults to `SUBMODULE_IGNORE_UNSPECIFIED`, which means the submodule's configuration will control  whether it appears in the diff or not.
  * `pathspec`: path to files to include in the diff. Default is to use all files in the repository.
  * `notify_cb`: optional callback which will notify the user of changes to the diff as file deltas are  added to it.
  * `progress_cb`: optional callback which will display diff progress. Only relevant on libgit2 versions  at least as new as 0.24.0.
  * `payload`: the payload to pass to `notify_cb` and `progress_cb`.
  * `context_lines`: the number of *unchanged* lines used to define the edges of a hunk.  This is also the number of lines which will be shown before/after a hunk to provide  context. Default is 3.
  * `interhunk_lines`: the maximum number of *unchanged* lines *between* two separate  hunks allowed before the hunks will be combined. Default is 0.
  * `id_abbrev`: sets the length of the abbreviated [`GitHash`](@ref) to print.  Default is `7`.
  * `max_size`: the maximum file size of a blob. Above this size, it will be treated  as a binary blob. The default is 512 MB.
  * `old_prefix`: the virtual file directory in which to place old files on one side  of the diff. Default is `"a"`.
  * `new_prefix`: the virtual file directory in which to place new files on one side  of the diff. Default is `"b"`.
