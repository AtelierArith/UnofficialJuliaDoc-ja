```julia
channeled_tasks(n::Int, funcs...; ctypes=fill(Any,n), csizes=fill(0,n))
```

A convenience method to create `n` channels and bind them to tasks started from the provided functions in a single call. Each `func` must accept `n` arguments which are the created channels. Channel types and sizes may be specified via keyword arguments `ctypes` and `csizes` respectively. If unspecified, all channels are of type `Channel{Any}(0)`.

Returns a tuple, `(Array{Channel}, Array{Task})`, of the created channels and tasks.
