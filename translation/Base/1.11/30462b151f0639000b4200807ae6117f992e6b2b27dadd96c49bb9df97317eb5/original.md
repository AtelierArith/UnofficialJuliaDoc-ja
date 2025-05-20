lock(f::Function, l::Lockable)

Acquire the lock associated with `l`, execute `f` with the lock held, and release the lock when `f` returns. `f` will receive one positional argument: the value wrapped by `l`. If the lock is already locked by a different task/thread, wait for it to become available. When this function returns, the `lock` has been released, so the caller should not attempt to `unlock` it.

!!! compat "Julia 1.11"
    Requires at least Julia 1.11.

