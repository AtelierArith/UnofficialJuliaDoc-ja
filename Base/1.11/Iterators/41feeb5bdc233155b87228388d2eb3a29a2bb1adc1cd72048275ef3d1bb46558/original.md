```
Iterators.reverse(itr)
```

Given an iterator `itr`, then `reverse(itr)` is an iterator over the same collection but in the reverse order. This iterator is "lazy" in that it does not make a copy of the collection in order to reverse it; see [`Base.reverse`](@ref) for an eager implementation.

(By default, this returns an `Iterators.Reverse` object wrapping `itr`, which is iterable if the corresponding [`iterate`](@ref) methods are defined, but some `itr` types may implement more specialized `Iterators.reverse` behaviors.)

Not all iterator types `T` support reverse-order iteration.  If `T` doesn't, then iterating over `Iterators.reverse(itr::T)` will throw a [`MethodError`](@ref) because of the missing `iterate` methods for `Iterators.Reverse{T}`. (To implement these methods, the original iterator `itr::T` can be obtained from an `r::Iterators.Reverse{T}` object by `r.itr`; more generally, one can use `Iterators.reverse(r)`.)

# Examples

```jldoctest
julia> foreach(println, Iterators.reverse(1:5))
5
4
3
2
1
```
