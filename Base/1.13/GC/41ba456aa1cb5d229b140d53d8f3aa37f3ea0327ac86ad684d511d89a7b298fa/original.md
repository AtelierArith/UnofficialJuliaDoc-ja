```julia
GC.enable_finalizers(on::Bool)
```

Increment or decrement the counter that controls the running of finalizers on the current Task. Finalizers will only run when the counter is at zero. (Set `true` for enabling, `false` for disabling). They may still run concurrently on another Task or thread.
