```julia
empty!(collection) -> collection
```

Remove all elements from a `collection`.

# Examples

```jldoctest
julia> A = Dict("a" => 1, "b" => 2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

julia> empty!(A);

julia> A
Dict{String, Int64}()
```
