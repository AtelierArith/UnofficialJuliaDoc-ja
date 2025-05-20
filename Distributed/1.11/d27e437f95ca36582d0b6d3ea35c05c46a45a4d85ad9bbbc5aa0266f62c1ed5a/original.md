```
put!(rr::Future, v)
```

Store a value to a [`Future`](@ref) `rr`. `Future`s are write-once remote references. A `put!` on an already set `Future` throws an `Exception`. All asynchronous remote calls return `Future`s and set the value to the return value of the call upon completion.
