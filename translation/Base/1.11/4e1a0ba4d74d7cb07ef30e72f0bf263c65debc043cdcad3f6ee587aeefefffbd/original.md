```
ntuple(f, n::Integer)
```

Create a tuple of length `n`, computing each element as `f(i)`, where `i` is the index of the element.

# Examples

```jldoctest
julia> ntuple(i -> 2*i, 4)
(2, 4, 6, 8)
```
