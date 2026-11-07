```julia
get_num_threads()
```

Get the number of threads the BLAS library is using.

!!! compat "Julia 1.6"
    `get_num_threads` requires at least Julia 1.6.


!!! note
    Some BLAS libraries, such as Apple Accelerate, cannot be configured to use a fixed number of threads. For these backends, `get_num_threads()` always returns `1`. See also [`set_num_threads`](@ref).

