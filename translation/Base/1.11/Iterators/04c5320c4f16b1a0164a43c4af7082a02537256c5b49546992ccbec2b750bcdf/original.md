```
dropwhile(pred, iter)
```

An iterator that drops element from `iter` as long as predicate `pred` is true, afterwards, returns every element.

!!! compat "Julia 1.4"
    This function requires at least Julia 1.4.


# Examples

```jldoctest
julia> s = collect(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

julia> collect(Iterators.dropwhile(<(3),s))
3-element Vector{Int64}:
 3
 4
 5
```
