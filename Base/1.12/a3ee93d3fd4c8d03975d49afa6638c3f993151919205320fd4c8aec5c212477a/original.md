```julia
ReentrantLock()
```

Creates a re-entrant lock for synchronizing [`Task`](@ref)s. The same task can acquire the lock as many times as required (this is what the "Reentrant" part of the name means). Each [`lock`](@ref) must be matched with an [`unlock`](@ref).

Calling `lock` will also inhibit running of finalizers on that thread until the corresponding `unlock`. Use of the standard lock pattern illustrated below should naturally be supported, but beware of inverting the try/lock order or missing the try block entirely (e.g. attempting to return with the lock still held):

This provides a acquire/release memory ordering on lock/unlock calls.

```julia
lock(l)
try
    <atomic work>
finally
    unlock(l)
end
```

If [`!islocked(lck::ReentrantLock)`](@ref islocked) holds, [`trylock(lck)`](@ref trylock) succeeds unless there are other tasks attempting to hold the lock "at the same time."
