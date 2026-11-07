```julia
acquire(f, s::Semaphore)
```

Execute `f` after acquiring from Semaphore `s`, and `release` on completion or error.

For example, a do-block form that ensures only 2 calls of `foo` will be active at the same time:

```julia
s = Base.Semaphore(2)
@sync for _ in 1:100
    Threads.@spawn begin
        Base.acquire(s) do
            foo()
        end
    end
end
```

!!! compat "Julia 1.8"
    This method requires at least Julia 1.8.

