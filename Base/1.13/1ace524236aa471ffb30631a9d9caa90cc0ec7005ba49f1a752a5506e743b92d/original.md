```julia
AlwaysLockedST
```

This struct does not implement a real lock, but instead pretends to be always locked on the original thread it was allocated on, and simply ignores all other interactions. It also does not synchronize tasks; for that use a real lock such as [`ReentrantLock`](@ref). This can be used in the place of a real lock to, instead, simply and cheaply assert that the operation is only occurring on a single cooperatively-scheduled thread. It is thus functionally equivalent to allocating a real, recursive, task-unaware lock immediately calling `lock` on it, and then never calling a matching `unlock`, except that calling `lock` from another thread will throw a concurrency violation exception.
