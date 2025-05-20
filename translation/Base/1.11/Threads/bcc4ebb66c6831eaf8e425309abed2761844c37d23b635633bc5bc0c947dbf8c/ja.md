```
Threads.threadpoolsize(pool::Symbol = :default) -> Int
```

デフォルトのスレッドプール（または指定されたスレッドプール）で利用可能なスレッドの数を取得します。

関連情報: [`LinearAlgebra`](@ref man-linalg) 標準ライブラリの `BLAS.get_num_threads` および `BLAS.set_num_threads`、および [`Distributed`](@ref man-distributed) 標準ライブラリの `nprocs()`。
