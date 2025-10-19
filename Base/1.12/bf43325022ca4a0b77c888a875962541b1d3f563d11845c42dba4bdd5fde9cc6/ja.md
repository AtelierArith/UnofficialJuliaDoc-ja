```julia
@sync
```

すべての字句的に囲まれた [`@async`](@ref)、[`@spawn`](@ref Threads.@spawn)、`Distributed.@spawnat` および `Distributed.@distributed` の使用が完了するまで待機します。囲まれた非同期操作によってスローされたすべての例外は収集され、[`CompositeException`](@ref) としてスローされます。

# 例

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
