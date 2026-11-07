```julia
set_num_threads(n::Integer)
set_num_threads(::Nothing)
```

Set the number of threads the BLAS library should use equal to `n::Integer`.

Also accepts `nothing`, in which case julia tries to guess the default number of threads. Passing `nothing` is discouraged and mainly exists for historical reasons.

!!! note
    Some BLAS libraries, such as Apple Accelerate, cannot be configured to use a fixed number of threads. For these backends, `set_num_threads()` is a no-op. See also [`get_num_threads`](@ref).

