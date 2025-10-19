```julia
IdDict([itr])
```

`IdDict{K,V}()` constructs a hash table using [`objectid`](@ref) as hash and `===` as equality with keys of type `K` and values of type `V`. See [`Dict`](@ref) for further help and [`IdSet`](@ref) for the set version of this.

In the example below, the `Dict` keys are all `isequal` and therefore get hashed the same, so they get overwritten. The `IdDict` hashes by object-id, and thus preserves the 3 different keys.

# Examples

```julia-repl
julia> Dict(true => "yes", 1 => "no", 1.0 => "maybe")
Dict{Real, String} with 1 entry:
  1.0 => "maybe"

julia> IdDict(true => "yes", 1 => "no", 1.0 => "maybe")
IdDict{Any, String} with 3 entries:
  true => "yes"
  1.0  => "maybe"
  1    => "no"
```
