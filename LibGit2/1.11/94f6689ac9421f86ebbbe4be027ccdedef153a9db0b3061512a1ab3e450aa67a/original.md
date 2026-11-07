```julia
fetch(repo::GitRepo; kwargs...)
```

Fetches updates from an upstream of the repository `repo`.

The keyword arguments are:

  * `remote::AbstractString="origin"`: which remote, specified by name, of `repo` to fetch from. If this is empty, the URL will be used to construct an anonymous remote.
  * `remoteurl::AbstractString=""`: the URL of `remote`. If not specified, will be assumed based on the given name of `remote`.
  * `refspecs=AbstractString[]`: determines properties of the fetch.
  * `depth::Integer=0`: limit fetching to the specified number of commits from the tip of each remote branch. `0` indicates a full fetch (the default). Use `Consts.FETCH_DEPTH_UNSHALLOW` to fetch all missing data from a shallow clone. Note: depth is, at the time of writing, only supported for network protocols (http, https, git, ssh), not for local filesystem paths. (https://github.com/libgit2/libgit2/issues/6634)
  * `credentials=nothing`: provides credentials and/or settings when authenticating against a private `remote`.
  * `callbacks=Callbacks()`: user provided callbacks and payloads.

Equivalent to `git fetch [--depth <depth>] [<remoteurl>|<repo>] [<refspecs>]`.
