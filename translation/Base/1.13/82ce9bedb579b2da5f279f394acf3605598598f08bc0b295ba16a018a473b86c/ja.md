```julia
empty!(collection) -> collection
```

`collection` からすべての要素を削除します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> A = Dict("a" => 1, "b" => 2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

julia> empty!(A);

julia> A
Dict{String, Int64}()
```
