```julia
@sync
```

Wait until all lexically-enclosed uses of [`@async`](@ref), [`@spawn`](@ref Threads.@spawn), `Distributed.@spawnat` and `Distributed.@distributed` are complete. All exceptions thrown by enclosed async operations are collected and thrown as a [`CompositeException`](@ref).

# Examples

```julia-repl
julia> Threads.nthreads()
4

julia> @sync begin
           Threads.@spawn println("Thread-id $(Threads.threadid()), task 1")
           Threads.@spawn println("Thread-id $(Threads.threadid()), task 2")
       end;
Thread-id 3, task 1
Thread-id 1, task 2
```
