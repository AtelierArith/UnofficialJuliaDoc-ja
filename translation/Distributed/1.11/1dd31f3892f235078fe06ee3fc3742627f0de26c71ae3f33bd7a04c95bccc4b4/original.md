```
worker_id_from_socket(s) -> pid
```

A low-level API which, given a `IO` connection or a `Worker`, returns the `pid` of the worker it is connected to. This is useful when writing custom [`serialize`](@ref) methods for a type, which optimizes the data written out depending on the receiving process id.
