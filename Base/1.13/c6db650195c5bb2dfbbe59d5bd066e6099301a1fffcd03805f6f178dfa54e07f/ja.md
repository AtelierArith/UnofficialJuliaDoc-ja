```julia
@sync
```

`Distributed.@spawnat`、`Distributed.@distributed`、[`@async`](@ref)、[`@spawn`](@ref Threads.@spawn)で字句的に囲まれたすべての処理が完了するまで待機します。囲まれた非同期処理でスローされた例外はすべて収集され、[`CompositeException`](@ref)としてスローされます。

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
