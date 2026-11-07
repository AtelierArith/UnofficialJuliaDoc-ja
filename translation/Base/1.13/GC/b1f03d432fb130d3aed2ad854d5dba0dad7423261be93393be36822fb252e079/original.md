```julia
GC.in_finalizer()::Bool
```

Returns `true` if the current task is running a finalizer, returns `false` otherwise. Will also return `false` within a finalizer which was inlined by the compiler's eager finalization optimization, or if `finalize` is called on the finalizer directly.

The result of this function may be useful, for example, when a finalizer must wait on a resource to become available; instead of polling the resource in a `yield` loop (which is not legal to execute within a task running finalizers), busy polling or an `@async` continuation could be used instead.
