```julia
LibGit2.ApplyOptions
```

Options for applying a diff. Matches the [`git_apply_options`](https://libgit2.org/libgit2/#HEAD/type/git_apply_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `delta_cb`: optional callback that will be made before each delta is applied.
  * `hunk_cb`: optional callback that will be made before each hunk is applied.
  * `payload`: the payload for the callback functions.
  * `flags`: flags controlling how the apply is performed (e.g., check mode).
