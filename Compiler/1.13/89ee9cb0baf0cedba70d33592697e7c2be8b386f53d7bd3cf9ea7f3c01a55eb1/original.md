```julia
IRCode()
```

Create an empty IRCode object with a single `return nothing` statement. This method is mostly intended for debugging and unit testing of IRCode APIs. The compiler itself should generally obtain an IRCode from the frontend or one of the caches.
