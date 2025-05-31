```
release(pool::Pool{K, T}, key::K, obj::Union{T, Nothing}=nothing)
release(pool::Pool{K, T}, obj::T)
release(pool::Pool{K, T})
```

Release an object from usage by a `pool`, optionally keyed by the provided `key`. If `obj` is provided, it will be returned to the pool for reuse. Otherwise, if `nothing` is returned, or `release(pool)` is called, the usage count will be decremented without an object being returned to the pool for reuse.
