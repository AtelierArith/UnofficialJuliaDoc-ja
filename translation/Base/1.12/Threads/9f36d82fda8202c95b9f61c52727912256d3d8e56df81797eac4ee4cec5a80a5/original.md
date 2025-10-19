```julia
Threads.threadid([t::Task]) -> Int
```

Get the ID number of the current thread of execution, or the thread of task `t`. The master thread has ID `1`.

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

julia> Threads.threadid(Threads.@spawn "foo")
2
```

!!! note
    The thread that a task runs on may change if the task yields, which is known as [`Task Migration`](@ref man-task-migration). For this reason in most cases it is not safe to use `threadid([task])` to index into, say, a vector of buffers or stateful objects.

