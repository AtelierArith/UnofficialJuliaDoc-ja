```
Threads.threadpoolsize(pool::Symbol = :default) -> Int
```

Get the number of threads available to the default thread pool (or to the specified thread pool).

See also: `BLAS.get_num_threads` and `BLAS.set_num_threads` in the [`LinearAlgebra`](@ref man-linalg) standard library, and `nprocs()` in the [`Distributed`](@ref man-distributed) standard library.
