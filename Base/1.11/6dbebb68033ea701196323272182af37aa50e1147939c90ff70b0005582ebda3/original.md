```
lock(f::Function, lock)
```

Acquire the `lock`, execute `f` with the `lock` held, and release the `lock` when `f` returns. If the lock is already locked by a different task/thread, wait for it to become available.

When this function returns, the `lock` has been released, so the caller should not attempt to `unlock` it.

See also: [`@lock`](@ref).

!!! compat "Julia 1.7"
    Using a [`Channel`](@ref) as the second argument requires Julia 1.7 or later.

