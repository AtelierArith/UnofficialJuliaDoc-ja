```
LibGit2.Callbacks
```

A dictionary which containing the callback name as the key and the value as a tuple of the callback function and payload.

The `Callback` dictionary to construct `RemoteCallbacks` allows each callback to use a distinct payload. Each callback, when called, will receive `Dict` which will hold the callback's custom payload which can be accessed using the callback name.

# Examples

```julia-repl
julia> c = LibGit2.Callbacks(:credentials => (LibGit2.credentials_cb(), LibGit2.CredentialPayload()));

julia> LibGit2.clone(url, callbacks=c);
```

See [`git_remote_callbacks`](https://libgit2.org/libgit2/#HEAD/type/git_remote_callbacks) for details on supported callbacks.
