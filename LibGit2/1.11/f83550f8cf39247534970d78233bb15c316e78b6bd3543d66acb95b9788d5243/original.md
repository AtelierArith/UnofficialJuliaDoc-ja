```julia
push(repo::GitRepo; kwargs...)
```

Pushes updates to an upstream of `repo`.

The keyword arguments are:

  * `remote::AbstractString="origin"`: the name of the upstream remote to push to.
  * `remoteurl::AbstractString=""`: the URL of `remote`.
  * `refspecs=AbstractString[]`: determines properties of the push.
  * `force::Bool=false`: determines if the push will be a force push,  overwriting the remote branch.
  * `credentials=nothing`: provides credentials and/or settings when authenticating against  a private `remote`.
  * `callbacks=Callbacks()`: user provided callbacks and payloads.

Equivalent to `git push [<remoteurl>|<repo>] [<refspecs>]`.
