```
isdone(itr, [state]) -> Union{Bool, Missing}
```

This function provides a fast-path hint for iterator completion. This is useful for stateful iterators that want to avoid having elements consumed if they are not going to be exposed to the user (e.g. when checking for done-ness in `isempty` or `zip`).

Stateful iterators that want to opt into this feature should define an `isdone` method that returns true/false depending on whether the iterator is done or not. Stateless iterators need not implement this function.

If the result is `missing`, callers may go ahead and compute `iterate(x, state) === nothing` to compute a definite answer.

See also [`iterate`](@ref), [`isempty`](@ref)
