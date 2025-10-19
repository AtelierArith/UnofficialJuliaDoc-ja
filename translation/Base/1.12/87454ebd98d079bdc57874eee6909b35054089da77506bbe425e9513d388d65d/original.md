```julia
typeintersect(T::Type, S::Type)
```

Compute a type that contains the intersection of `T` and `S`. Usually this will be the smallest such type or one close to it.

A special case where exact behavior is guaranteed: when `T <: S`, `typeintersect(S, T) == T == typeintersect(T, S)`.
