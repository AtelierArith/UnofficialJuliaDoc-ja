```julia
SyntaxHead(kind, flags)
```

A `SyntaxHead` combines the [`Kind`](@ref) of a syntactic construct with a set of flags. The kind defines the broad "type" of the syntactic construct, while the flag bits compactly store more detailed information about the construct.
