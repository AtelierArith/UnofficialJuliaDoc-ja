```julia
Base.getpass(message::AbstractString; with_suffix::Bool=true)::Base.SecretBuffer
```

Display a message and wait for the user to input a secret, returning an `IO` object containing the secret. If `with_suffix` is `true` (the default), the suffix `": "` will be appended to `message`.

!!! info "Windows"
    Note that on Windows, the secret might be displayed as it is typed; see `Base.winprompt` for securely retrieving username/password pairs from a graphical interface.


!!! compat "Julia 1.12"
    The `with_suffix` keyword argument requires at least Julia 1.12.


# Examples

```julia-repl
julia> Base.getpass("Secret")
Secret: SecretBuffer("*******")

julia> Base.getpass("Secret> "; with_suffix=false)
Secret> SecretBuffer("*******")
```
