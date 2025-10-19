```julia
Timer(callback::Function, delay; interval = 0, spawn::Union{Nothing,Bool}=nothing)
```

Create a timer that runs the function `callback` at each timer expiration.

Waiting tasks are woken and the function `callback` is called after an initial delay of `delay` seconds, and then repeating with the given `interval` in seconds. If `interval` is equal to `0`, the callback is only run once. The function `callback` is called with a single argument, the timer itself. Stop a timer by calling `close`. The `callback` may still be run one final time, if the timer has already expired.

If `spawn` is `true`, the created task will be spawned, meaning that it will be allowed to move thread, which avoids the side-effect of forcing the parent task to get stuck to the thread it is on. If `spawn` is `nothing` (default), the task will be spawned if the parent task isn't sticky.

!!! compat "Julia 1.12"
    The `spawn` argument was introduced in Julia 1.12.


# Examples

Here the first number is printed after a delay of two seconds, then the following numbers are printed quickly.

```julia-repl
julia> begin
           i = 0
           cb(timer) = (global i += 1; println(i))
           t = Timer(cb, 2, interval=0.2)
           wait(t)
           sleep(0.5)
           close(t)
       end
1
2
3
```
