```
LibGit2.FetchOptions
```

Matches the [`git_fetch_options`](https://libgit2.org/libgit2/#HEAD/type/git_fetch_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `callbacks`: remote callbacks to use during the fetch.
  * `prune`: whether to perform a prune after the fetch or not. The default is to  use the setting from the `GitConfig`.
  * `update_fetchhead`: whether to update the [`FetchHead`](@ref) after the fetch.  The default is to perform the update, which is the normal git behavior.
  * `download_tags`: whether to download tags present at the remote or not. The default  is to request the tags for objects which are being downloaded anyway from the server.
  * `proxy_opts`: options for connecting to the remote through a proxy. See [`ProxyOptions`](@ref).  Only present on libgit2 versions newer than or equal to 0.25.0.
  * `custom_headers`: any extra headers needed for the fetch. Only present on libgit2 versions  newer than or equal to 0.24.0.
