```
copymutable(a)
```

Make a mutable copy of an array or iterable `a`.  For `a::Array`, this is equivalent to `copy(a)`, but for other array types it may differ depending on the type of `similar(a)`.  For generic iterables this is equivalent to `collect(a)`.

# Examples

```jldoctest
julia> tup = (1, 2, 3)
(1, 2, 3)

julia> Base.copymutable(tup)
3-element Vector{Int64}:
 1
 2
 3
```
