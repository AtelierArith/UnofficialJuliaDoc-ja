```julia
struct GreenNode
```

An explicit pointer-y representation of the green tree produced by the parser. See [`RawGreenNode`](@ref) for documentation on working with the implicit green tree directly. However, this representation is useful for introspection as it provides O(1) access to the children (as well as forward iteration).
