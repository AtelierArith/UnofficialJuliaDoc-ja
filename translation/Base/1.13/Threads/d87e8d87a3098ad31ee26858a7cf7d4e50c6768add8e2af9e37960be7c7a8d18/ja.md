```julia
Threads.nthreads(:default | :interactive)::Int
```

指定したスレッドプール内の現在のスレッド数を取得します。`:interactive` 内のスレッドの ID 番号は `1:nthreads(:interactive)` で、`:default` 内のスレッドの ID 番号は `nthreads(:interactive) .+ (1:nthreads(:default))` です。

[`LinearAlgebra`](@ref man-linalg) 標準ライブラリの `BLAS.get_num_threads` と `BLAS.set_num_threads`、および [`Distributed`](@ref man-distributed) 標準ライブラリの `nprocs()` と [`Threads.maxthreadid()`](@ref) も参照してください。
