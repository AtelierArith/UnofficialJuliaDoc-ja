```julia
BroadcastStyle(::Style1, ::Style2) = Style3()
```

Indicate how to resolve different `BroadcastStyle`s. For example,

```julia
BroadcastStyle(::Primary, ::Secondary) = Primary()
```

would indicate that style `Primary` has precedence over `Secondary`. You do not have to (and generally should not) define both argument orders. The result does not have to be one of the input arguments, it could be a third type.

Please see the [Interfaces chapter](@ref man-interfaces-broadcasting) of the manual for more information.
