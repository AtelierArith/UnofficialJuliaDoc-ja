```
get(collection, key, default)
```

Return the value stored for the given key, or the given default value if no mapping for the key is present.

!!! compat "Julia 1.7"
    For tuples and numbers, this function requires at least Julia 1.7.


# Examples

```jldoctest
julia> d = Dict("a"=>1, "b"=>2);

julia> get(d, "a", 3)
1

julia> get(d, "c", 3)
3
```
