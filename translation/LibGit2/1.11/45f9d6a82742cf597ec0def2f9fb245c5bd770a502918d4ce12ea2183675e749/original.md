```
push(rmt::GitRemote, refspecs; force::Bool=false, options::PushOptions=PushOptions())
```

Push to the specified `rmt` remote git repository, using `refspecs` to determine which remote branch(es) to push to. The keyword arguments are:

  * `force`: if `true`, a force-push will occur, disregarding conflicts.
  * `options`: determines the options for the push, e.g. which proxy headers to use. See [`PushOptions`](@ref) for more information.

!!! note
    You can add information about the push refspecs in two other ways: by setting an option in the repository's `GitConfig` (with `push.default` as the key) or by calling [`add_push!`](@ref). Otherwise you will need to explicitly specify a push refspec in the call to `push` for it to have any effect, like so: `LibGit2.push(repo, refspecs=["refs/heads/master"])`.

