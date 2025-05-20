```
Threads.foreach(f, channel::Channel;
                schedule::Threads.AbstractSchedule=Threads.FairSchedule(),
                ntasks=Threads.threadpoolsize())
```

Similar to `foreach(f, channel)`, but iteration over `channel` and calls to `f` are split across `ntasks` tasks spawned by `Threads.@spawn`. This function will wait for all internally spawned tasks to complete before returning.

If `schedule isa FairSchedule`, `Threads.foreach` will attempt to spawn tasks in a manner that enables Julia's scheduler to more freely load-balance work items across threads. This approach generally has higher per-item overhead, but may perform better than `StaticSchedule` in concurrence with other multithreaded workloads.

If `schedule isa StaticSchedule`, `Threads.foreach` will spawn tasks in a manner that incurs lower per-item overhead than `FairSchedule`, but is less amenable to load-balancing. This approach thus may be more suitable for fine-grained, uniform workloads, but may perform worse than `FairSchedule` in concurrence with other multithreaded workloads.

# Examples

```julia-repl
julia> n = 20

julia> c = Channel{Int}(ch -> foreach(i -> put!(ch, i), 1:n), 1)

julia> d = Channel{Int}(n) do ch
           f = i -> put!(ch, i^2)
           Threads.foreach(f, c)
       end

julia> collect(d)
collect(d) = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400]
```

!!! compat "Julia 1.6"
    This function requires Julia 1.6 or later.

