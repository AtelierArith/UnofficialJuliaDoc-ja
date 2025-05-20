```
ls(rmt::GitRemote) -> Vector{GitRemoteHead}
```

Get the remote repository's reference advertisement list.

This function must only be called after connecting (See [`connect`](@ref)).
