```julia
LibGit2.CloneOptions
```

Matches the [`git_clone_options`](https://libgit2.org/libgit2/#HEAD/type/git_clone_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `checkout_opts`: The options for performing the checkout of the remote as part of the clone.
  * `fetch_opts`: The options for performing the pre-checkout fetch of the remote as part of the clone.
  * `bare`: If `0`, clone the full remote repository. If non-zero, perform a bare clone, in which  there is no local copy of the source files in the repository and the [`gitdir`](@ref) and [`workdir`](@ref)  are the same.
  * `localclone`: Flag whether to clone a local object database or do a fetch. The default is to let git decide.  It will not use the git-aware transport for a local clone, but will use it for URLs which begin with `file://`.
  * `checkout_branch`: The name of the branch to checkout. If an empty string, the default branch of the  remote will be checked out.
  * `repository_cb`: An optional callback which will be used to create the *new* repository into which  the clone is made.
  * `repository_cb_payload`: The payload for the repository callback.
  * `remote_cb`: An optional callback used to create the [`GitRemote`](@ref) before making the clone from it.
  * `remote_cb_payload`: The payload for the remote callback.
