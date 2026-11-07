```julia
Threads.threadpool(tid = threadid())::Symbol
```

指定したスレッドのスレッドプールを返します。戻り値は `:default`、`:interactive`、または `:foreign` です。
