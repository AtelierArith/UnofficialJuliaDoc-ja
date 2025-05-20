```
modifyproperty!(x, f::Symbol, op, v, order::Symbol=:not_atomic)
```

The syntax `@atomic op(x.f, v)` (and its equivalent `@atomic x.f op v`) returns `modifyproperty!(x, :f, op, v, :sequentially_consistent)`, where the first argument must be a `getproperty` expression and is modified atomically.

Invocation of `op(getproperty(x, f), v)` must return a value that can be stored in the field `f` of the object `x` by default.  In particular, unlike the default behavior of [`setproperty!`](@ref Base.setproperty!), the `convert` function is not called automatically.

See also [`modifyfield!`](@ref Core.modifyfield!) and [`setproperty!`](@ref Base.setproperty!).
