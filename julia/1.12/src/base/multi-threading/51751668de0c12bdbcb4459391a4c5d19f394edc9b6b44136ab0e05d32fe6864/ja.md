# [Multi-Threading](@id lib-multithreading)

```@docs
Base.Threads.@threads
Base.Threads.foreach
Base.Threads.@spawn
Base.Threads.threadid
Base.Threads.maxthreadid
Base.Threads.nthreads
Base.Threads.threadpool
Base.Threads.nthreadpools
Base.Threads.threadpoolsize
Base.Threads.ngcthreads
```

See also [Multi-Threading](@ref man-multithreading).

## Atomic operations

```@docs
atomic
```

```@docs
Base.@atomic
Base.@atomicswap
Base.@atomicreplace
Base.@atomiconce
Base.AtomicMemory
```

`unsafe` 関数のセットには、これらの原子操作の C/C++ 互換バージョンを選択するオプションのメモリ順序パラメータもあります。このパラメータが指定されている場合、[`unsafe_load`](@ref)、[`unsafe_store!`](@ref)、[`unsafe_swap!`](@ref)、[`unsafe_replace!`](@ref)、および [`unsafe_modify!`](@ref) が使用されます。

!!! warning
    以下のAPIは非推奨ですが、サポートは数回のリリースにわたって残る可能性があります。


```@docs
Base.Threads.Atomic
Base.Threads.atomic_cas!
Base.Threads.atomic_xchg!
Base.Threads.atomic_add!
Base.Threads.atomic_sub!
Base.Threads.atomic_and!
Base.Threads.atomic_nand!
Base.Threads.atomic_or!
Base.Threads.atomic_xor!
Base.Threads.atomic_max!
Base.Threads.atomic_min!
Base.Threads.atomic_fence
```

## ccall using a libuv threadpool (Experimental)

```@docs
Base.@threadcall
```

## Low-level synchronization primitives

これらのビルディングブロックは、通常の同期オブジェクトを作成するために使用されます。

```@docs
Base.Threads.SpinLock
```

## Task metrics (Experimental)

```@docs
Base.Experimental.task_metrics
Base.Experimental.task_running_time_ns
Base.Experimental.task_wall_time_ns
```
