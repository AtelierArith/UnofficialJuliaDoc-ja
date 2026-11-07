```julia
Threads.threadpool(tid = threadid())::Symbol
```

指定したスレッドのスレッドプールを返します。`:default`、`:interactive`、または`:foreign`のいずれかです。
