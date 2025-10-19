```julia
===(x,y) -> Bool
≡(x,y) -> Bool
```

Determine whether `x` and `y` are identical, in the sense that no program could distinguish them. First the types of `x` and `y` are compared. If those are identical, mutable objects are compared by address in memory and immutable objects (such as numbers) are compared by contents at the bit level. This function is sometimes called "egal". It always returns a `Bool` value.

# Examples

```jldoctest
julia> a = [1, 2]; b = [1, 2];

julia> a == b
true

julia> a === b
false

julia> a === a
true
```
