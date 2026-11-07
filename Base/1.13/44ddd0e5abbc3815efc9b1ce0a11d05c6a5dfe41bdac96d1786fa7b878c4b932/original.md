```julia
Channel{T=Any}(func::Function, size=0; taskref=nothing, spawn=false, threadpool=nothing)
```

Create a new task from `func`, [`bind`](@ref) it to a new channel of type `T` and size `size`, and schedule the task, all in a single call. The channel is automatically closed when the task terminates.

`func` must accept the bound channel as its only argument.

If you need a reference to the created task, pass a `Ref{Task}` object via the keyword argument `taskref`.

If `spawn=true`, the `Task` created for `func` may be scheduled on another thread in parallel, equivalent to creating a task via [`Threads.@spawn`](@ref).

If `spawn=true` and the `threadpool` argument is not set, it defaults to `:default`.

If the `threadpool` argument is set (to `:default` or `:interactive`), this implies that `spawn=true` and the new Task is spawned to the specified threadpool.

Return a `Channel`.

# Examples

```jldoctest
julia> chnl = Channel() do ch
           foreach(i -> put!(ch, i), 1:4)
       end;

julia> typeof(chnl)
Channel{Any}

julia> for i in chnl
           @show i
       end;
i = 1
i = 2
i = 3
i = 4
```

Referencing the created task:

```jldoctest
julia> taskref = Ref{Task}();

julia> chnl = Channel(taskref=taskref) do ch
           println(take!(ch))
       end;

julia> istaskdone(taskref[])
false

julia> put!(chnl, "Hello");
Hello

julia> istaskdone(taskref[])
true
```

!!! compat "Julia 1.3"
    The `spawn=` parameter was added in Julia 1.3. This constructor was added in Julia 1.3. In earlier versions of Julia, Channel used keyword arguments to set `size` and `T`, but those constructors are deprecated.


!!! compat "Julia 1.9"
    The `threadpool=` argument was added in Julia 1.9.


```jldoctest
julia> chnl = Channel{Char}(1, spawn=true) do ch
           for c in "hello world"
               put!(ch, c)
           end
       end;

julia> String(collect(chnl))
"hello world"
```
