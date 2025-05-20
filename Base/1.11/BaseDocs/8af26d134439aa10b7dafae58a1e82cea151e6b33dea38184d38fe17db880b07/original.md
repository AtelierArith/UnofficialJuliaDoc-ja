```
UndefVarError(var::Symbol, [scope])
```

A symbol in the current scope is not defined.

# Examples

```jldoctest
julia> a
ERROR: UndefVarError: `a` not defined in `Main`

julia> a = 1;

julia> a
1
```
