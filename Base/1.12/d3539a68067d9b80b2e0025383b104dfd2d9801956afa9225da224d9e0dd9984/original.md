```julia
IteratorSize(itertype::Type) -> IteratorSize
```

Given the type of an iterator, return one of the following values:

  * `SizeUnknown()` if the length (number of elements) cannot be determined in advance.
  * `HasLength()` if there is a fixed, finite length.
  * `HasShape{N}()` if there is a known length plus a notion of multidimensional shape (as for an array).  In this case `N` should give the number of dimensions, and the [`axes`](@ref) function is valid  for the iterator.
  * `IsInfinite()` if the iterator yields values forever.

The default value (for iterators that do not define this function) is `HasLength()`. This means that most iterators are assumed to implement [`length`](@ref).

This trait is generally used to select between algorithms that pre-allocate space for their result, and algorithms that resize their result incrementally.

```jldoctest
julia> Base.IteratorSize(1:5)
Base.HasShape{1}()

julia> Base.IteratorSize((2,3))
Base.HasLength()
```
