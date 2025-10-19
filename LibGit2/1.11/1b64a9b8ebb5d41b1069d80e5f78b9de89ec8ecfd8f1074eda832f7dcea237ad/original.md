```julia
LibGit2.PushOptions
```

Matches the [`git_push_options`](https://libgit2.org/libgit2/#HEAD/type/git_push_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `parallelism`: if a pack file must be created, this variable sets the number of worker  threads which will be spawned by the packbuilder. If `0`, the packbuilder will auto-set  the number of threads to use. The default is `1`.
  * `callbacks`: the callbacks (e.g. for authentication with the remote) to use for the push.
  * `proxy_opts`: only relevant if the LibGit2 version is greater than or equal to `0.25.0`.  Sets options for using a proxy to communicate with a remote. See [`ProxyOptions`](@ref)  for more information.
  * `custom_headers`: only relevant if the LibGit2 version is greater than or equal to `0.24.0`.  Extra headers needed for the push operation.
  * `remote_push_options`: only relevant if the LibGit2 version is greater than or equal to `1.8.0`.  "Push options" to deliver to the remote.
