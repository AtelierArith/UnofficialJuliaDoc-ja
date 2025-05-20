```
validargs(::Type{<:TimeType}, args...) -> Union{ArgumentError, Nothing}
```

Determine whether the given arguments constitute valid inputs for the given type. Returns either an `ArgumentError`, or [`nothing`](@ref) in case of success.
