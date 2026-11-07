```julia
AsyncCondition(callback::Function)
```

Create an async condition that calls the given `callback` function. The `callback` is passed one argument, the async condition object itself.
