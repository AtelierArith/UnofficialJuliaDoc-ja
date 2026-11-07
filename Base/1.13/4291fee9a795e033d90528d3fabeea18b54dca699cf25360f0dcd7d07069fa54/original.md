```julia
release(s::Semaphore)
```

Return one permit to the pool, possibly allowing another task to acquire it and resume execution.
