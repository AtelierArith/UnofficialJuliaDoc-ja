```julia
set_num_threads(n::Integer)
set_num_threads(::Nothing)
```

Set the number of threads the BLAS library should use equal to `n::Integer`.

Also accepts `nothing`, in which case julia tries to guess the default number of threads. Passing `nothing` is discouraged and mainly exists for historical reasons.
