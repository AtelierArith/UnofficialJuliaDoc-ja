```
LibGit2.RebaseOptions
```

Matches the `git_rebase_options` struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `quiet`: inform other git clients helping with/working on the rebase that the rebase should be done "quietly". Used for interoperability. The default is `1`.
  * `inmemory`: start an in-memory rebase. Callers working on the rebase can go through its steps and commit any changes, but cannot rewind HEAD or update the repository. The [`workdir`](@ref) will not be modified. Only present on libgit2 versions newer than or equal to 0.24.0.
  * `rewrite_notes_ref`: name of the reference to notes to use to rewrite the commit notes as the rebase is finished.
  * `merge_opts`: merge options controlling how the trees will be merged at each rebase step.  Only present on libgit2 versions newer than or equal to 0.24.0.
  * `checkout_opts`: checkout options for writing files when initializing the rebase, stepping through it, and aborting it. See [`CheckoutOptions`](@ref) for more information.
