```julia
OncePerThread{T}(init::Function)() -> T
```

Calling a `OncePerThread` object returns a value of type `T` by running the function `initializer` exactly once per thread. All future calls in the same thread, and concurrent or future calls with the same thread id, will return exactly the same value. The object can also be indexed by the threadid for any existing thread, to get (or initialize *on this thread*) the value stored for that thread. Incorrect usage can lead to data-races or memory corruption so use only if that behavior is correct within your library's threading-safety design.

!!! warning
    It is not necessarily true that a Task only runs on one thread, therefore the value returned here may alias other values or change in the middle of your program. This function may get deprecated in the future. If initializer yields, the thread running the current task after the call might not be the same as the one at the start of the call.


See also: [`OncePerTask`](@ref).

!!! compat "Julia 1.12"
    This type requires Julia 1.12 or later.


## Example

```jldoctest
julia> const thread_state = Base.OncePerThread{Vector{UInt32}}() do
           println("Making lazy thread value...done.")
           return [Libc.rand()]
       end;

julia> (threadvec = thread_state()) |> typeof
Making lazy thread value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> threadvec === fetch(@async thread_state())
true

julia> threadvec === thread_state[Threads.threadid()]
true
```
