```
Threads.nthreads(:default | :interactive) -> Int
```

指定されたスレッドプール内の現在のスレッド数を取得します。`:interactive` のスレッドは ID 番号 `1:nthreads(:interactive)` を持ち、`:default` のスレッドは `nthreads(:interactive) .+ (1:nthreads(:default))` の ID 番号を持ちます。

`BLAS.get_num_threads` および `BLAS.set_num_threads` は [`LinearAlgebra`](@ref man-linalg) 標準ライブラリに、`nprocs()` は [`Distributed`](@ref man-distributed) 標準ライブラリおよび [`Threads.maxthreadid()`](@ref) にあります。
