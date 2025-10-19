```julia
Iterators.filter(flt, itr)
```

Given a predicate function `flt` and an iterable object `itr`, return an iterable object which upon iteration yields the elements `x` of `itr` that satisfy `flt(x)`. The order of the original iterator is preserved.

This function is *lazy*; that is, it is guaranteed to return in $Θ(1)$ time and use $Θ(1)$ additional space, and `flt` will not be called by an invocation of `filter`. Calls to `flt` will be made when iterating over the returned iterable object. These calls are not cached and repeated calls will be made when reiterating.

!!! warning
    Subsequent *lazy* transformations on the iterator returned from `filter`, such as those performed by `Iterators.reverse` or `cycle`, will also delay calls to `flt` until collecting or iterating over the returned iterable object. If the filter predicate is nondeterministic or its return values depend on the order of iteration over the elements of `itr`, composition with lazy transformations may result in surprising behavior. If this is undesirable, either ensure that `flt` is a pure function or collect intermediate `filter` iterators before further transformations.


See [`Base.filter`](@ref) for an eager implementation of filtering for arrays.

# Examples

```jldoctest
julia> f = Iterators.filter(isodd, [1, 2, 3, 4, 5])
Base.Iterators.Filter{typeof(isodd), Vector{Int64}}(isodd, [1, 2, 3, 4, 5])

julia> foreach(println, f)
1
3
5

julia> [x for x in [1, 2, 3, 4, 5] if isodd(x)]  # collects a generator over Iterators.filter
3-element Vector{Int64}:
 1
 3
 5
```
