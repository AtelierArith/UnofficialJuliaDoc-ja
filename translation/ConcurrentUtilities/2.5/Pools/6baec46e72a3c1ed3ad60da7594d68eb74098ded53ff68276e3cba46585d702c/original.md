```julia
acquire(f, pool::Pool{K, T}, [key::K]; forcenew::Bool=false, isvalid::Function) -> T
```

Get an object from a `pool`, optionally keyed by the provided `key`. The provided function `f` must create a new object instance of type `T`. Each `acquire` call MUST be matched by exactly one `release` call. The `forcenew` keyword argument can be used to force the creation of a new object, ignoring any existing objects in the pool. The `isvalid` keyword argument can be used to specify a function that will be called to determine if an object is still valid for reuse. By default, all objects are considered valid. If there are no objects available for reuse, `f` will be called to create a new object. If the pool is already at its usage limit, `acquire` will block until an object is returned to the pool via `release`.
