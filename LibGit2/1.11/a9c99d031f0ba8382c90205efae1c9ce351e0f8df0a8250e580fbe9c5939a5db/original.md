```julia
LibGit2.ProxyOptions
```

Options for connecting through a proxy.

Matches the [`git_proxy_options`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `proxytype`: an `enum` for the type of proxy to use.  Defined in [`git_proxy_t`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_t).  The corresponding Julia enum is `GIT_PROXY` and has values:

      * `PROXY_NONE`: do not attempt the connection through a proxy.
      * `PROXY_AUTO`: attempt to figure out the proxy configuration from the git configuration.
      * `PROXY_SPECIFIED`: connect using the URL given in the `url` field of this struct.

    Default is to auto-detect the proxy type.
  * `url`: the URL of the proxy.
  * `credential_cb`: a pointer to a callback function which will be called if the remote requires authentication to connect.
  * `certificate_cb`: a pointer to a callback function which will be called if certificate verification fails. This lets the user decide whether or not to keep connecting. If the function returns `1`, connecting will be allowed. If it returns `0`, the connection will not be allowed. A negative value can be used to return errors.
  * `payload`: the payload to be provided to the two callback functions.

# Examples

```julia-repl
julia> fo = LibGit2.FetchOptions(
           proxy_opts = LibGit2.ProxyOptions(url = Cstring("https://my_proxy_url.com")))

julia> fetch(remote, "master", options=fo)
```
