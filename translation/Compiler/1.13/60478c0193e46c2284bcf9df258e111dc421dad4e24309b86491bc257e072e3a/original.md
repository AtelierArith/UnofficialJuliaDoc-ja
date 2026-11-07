```julia
is_immutable_argtype(argtype)::Bool
```

Return `true` if the `argtype` object is known to be immutable. This query is specifically designed for `getfield_effects` and `isdefined_effects`, allowing them to prove `:consistent`-cy of `getfield` / `isdefined` calls when applied to immutable objects. Otherwise, we need to additionally prove that the non-immutable object is not a global object to prove the `:consistent`-cy.
