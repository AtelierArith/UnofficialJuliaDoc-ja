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

こちらも参照してください。[Multi-Threading](@ref man-multithreading)。

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

`unsafe` の関数群には、オプションでメモリ順序を指定するパラメーターもあります。このパラメーターを [`unsafe_load`](@ref)、[`unsafe_store!`](@ref)、[`unsafe_swap!`](@ref)、[`unsafe_replace!`](@ref)、[`unsafe_modify!`](@ref) に指定すると、これらのアトミック操作の C/C++ 互換版が選択されます。

!!! warning
    以下の API は非推奨ですが、今後数回のリリースにわたってサポートが継続される見込みです。


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

これらの基本要素を組み合わせて、通常の同期オブジェクトを作成します。

```@docs
Base.Threads.AbstractSpinLock
Base.Threads.SpinLock
Base.Threads.PaddedSpinLock
```

## Task metrics (Experimental)

```@docs
Base.Experimental.task_metrics
Base.Experimental.task_running_time_ns
Base.Experimental.task_wall_time_ns
```
