```julia
Threads.nthreads(:default | :interactive) -> Int
```

Get the current number of threads within the specified thread pool. The threads in `:interactive` have id numbers `1:nthreads(:interactive)`, and the threads in `:default` have id numbers in `nthreads(:interactive) .+ (1:nthreads(:default))`.

See also `BLAS.get_num_threads` and `BLAS.set_num_threads` in the [`LinearAlgebra`](@ref man-linalg) standard library, and `nprocs()` in the [`Distributed`](@ref man-distributed) standard library and [`Threads.maxthreadid()`](@ref).
