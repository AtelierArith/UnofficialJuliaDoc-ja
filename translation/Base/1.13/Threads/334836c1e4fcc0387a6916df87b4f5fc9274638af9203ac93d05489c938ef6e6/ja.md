```julia
Threads.threadpoolsize(pool::Symbol = :default)::Int
```

デフォルトのスレッドプール（または指定したスレッドプール）で利用可能なスレッド数を取得します。

関連項目：[`LinearAlgebra`](@ref man-linalg) 標準ライブラリの `BLAS.get_num_threads` および `BLAS.set_num_threads`、ならびに [`Distributed`](@ref man-distributed) 標準ライブラリの `nprocs()`。
