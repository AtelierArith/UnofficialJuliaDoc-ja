```julia
CachingPool(workers::Vector{Int})
```

An implementation of an `AbstractWorkerPool`. [`remote`](@ref), [`remotecall_fetch`](@ref), [`pmap`](@ref) (and other remote calls which execute functions remotely) benefit from caching the serialized/deserialized functions on the worker nodes, especially closures (which may capture large amounts of data).

The remote cache is maintained for the lifetime of the returned `CachingPool` object. To clear the cache earlier, use `clear!(pool)`.

For global variables, only the bindings are captured in a closure, not the data. `let` blocks can be used to capture global data.

# Examples

```julia
const foo = rand(10^8);
wp = CachingPool(workers())
let foo = foo
    pmap(i -> sum(foo) + i, wp, 1:100);
end
```

The above would transfer `foo` only once to each worker.
