```julia
isTypeDataType(@nospecialize t)::Bool
```

For a type `t` test whether ∀S s.t. `isa(S, rewrap_unionall(Type{t}, ...))`, we have `isa(S, DataType)`. In particular, if a statement is typed as `Type{t}` (potentially wrapped in some `UnionAll`), then we are guaranteed that this statement will be a `DataType` at runtime (and not e.g. a `Union` or `UnionAll` typeequal to it).
