```
connect(rmt::GitRemote, direction::Consts.GIT_DIRECTION; kwargs...)
```

Open a connection to a remote. `direction` can be either `DIRECTION_FETCH` or `DIRECTION_PUSH`.

The keyword arguments are:

  * `credentials::Creds=nothing`: provides credentials and/or settings when authenticating against a private repository.
  * `callbacks::Callbacks=Callbacks()`: user provided callbacks and payloads.
