```
Threads.threadid() -> Int
```

Get the ID number of the current thread of execution. The master thread has ID `1`.

# Examples

```julia-repl
julia> Threads.threadid()
1

julia> Threads.@threads for i in 1:4
          println(Threads.threadid())
       end
4
2
5
4
```

!!! note
    The thread that a task runs on may change if the task yields, which is known as [`Task Migration`](@ref man-task-migration). For this reason in most cases it is not safe to use `threadid()` to index into, say, a vector of buffer or stateful objects.

