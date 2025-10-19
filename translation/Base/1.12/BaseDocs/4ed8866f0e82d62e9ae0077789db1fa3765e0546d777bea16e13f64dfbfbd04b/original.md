```julia
NamedTuple(itr)
```

Construct a named tuple from an iterator of key-value pairs (where the keys must be `Symbol`s). Equivalent to `(; itr...)`.

!!! compat "Julia 1.6"
    This method requires at least Julia 1.6.

