```julia
struct InternalCodeCache
```

Internally, each `MethodInstance` keep a unique global cache of code instances that have been created for the given method instance, stratified by world age ranges. This struct abstracts over access to this cache.
