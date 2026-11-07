```julia
WrappedException(msg)
```

Generic type for `Exception`s wrapping another `Exception`, such as `LoadError` and `InitError`. Those exceptions contain information about the root cause of an exception. Subtypes define a field `error` containing the causing `Exception`.
