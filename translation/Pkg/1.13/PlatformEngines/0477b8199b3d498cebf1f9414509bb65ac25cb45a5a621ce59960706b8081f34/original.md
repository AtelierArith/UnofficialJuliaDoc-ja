```julia
deregister_auth_error_handler(urlscheme::Union{AbstractString, Regex}, f)
```

Removes `f` from the stack of authentication error handlers.
