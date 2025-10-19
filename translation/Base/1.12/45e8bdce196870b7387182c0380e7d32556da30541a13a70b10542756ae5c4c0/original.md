```julia
@lock_conflicts
```

A macro to evaluate an expression, discard the resulting value, and instead return the total number of lock conflicts during evaluation, where a lock attempt on a [`ReentrantLock`](@ref) resulted in a wait because the lock was already held.

See also [`@time`](@ref), [`@timev`](@ref) and [`@timed`](@ref).

```julia-repl
julia> @lock_conflicts begin
    l = ReentrantLock()
    Threads.@threads for i in 1:Threads.nthreads()
        lock(l) do
        sleep(1)
        end
    end
end
5
```

!!! compat "Julia 1.11"
    This macro was added in Julia 1.11.

