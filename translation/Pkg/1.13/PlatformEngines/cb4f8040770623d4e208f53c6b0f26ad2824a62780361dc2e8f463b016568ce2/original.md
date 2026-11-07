```julia
register_auth_error_handler(urlscheme::Union{AbstractString, Regex}, f)
```

Registers `f` as the topmost handler for failures in package server authentication.

A handler is only invoked if `occursin(urlscheme, url)` is true (where `url` is the URL Pkg is currently trying to download.)

`f` must be a function that takes three input arguments `(url, pkgserver, err)`, where `url` is the URL currently being downloaded, `pkgserver = Pkg.pkg_server()` the current package server, and `err` is one of `no-auth-file`, `insecure-connection`, `malformed-file`, `no-access-token`, `no-refresh-key` or `insecure-refresh-url`.

The handler `f` needs to return a tuple of `Bool`s `(handled, should_retry)`. If `handled` is `false`, the next handler in the stack will be called, otherwise handling terminates; `get_auth_header` is called again if `should_retry` is `true`.

`register_auth_error_handler` returns a zero-arg function that can be called to deregister the handler.
