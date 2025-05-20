```
SpinLock()
```

Create a non-reentrant, test-and-test-and-set spin lock. Recursive use will result in a deadlock. This kind of lock should only be used around code that takes little time to execute and does not block (e.g. perform I/O). In general, [`ReentrantLock`](@ref) should be used instead.

Each [`lock`](@ref) must be matched with an [`unlock`](@ref). If [`!islocked(lck::SpinLock)`](@ref islocked) holds, [`trylock(lck)`](@ref trylock) succeeds unless there are other tasks attempting to hold the lock "at the same time."

Test-and-test-and-set spin locks are quickest up to about 30ish contending threads. If you have more contention than that, different synchronization approaches should be considered.
