```
IteratorEltype(itertype::Type) -> IteratorEltype
```

Given the type of an iterator, return one of the following values:

  * `EltypeUnknown()` if the type of elements yielded by the iterator is not known in advance.
  * `HasEltype()` if the element type is known, and [`eltype`](@ref) would return a meaningful value.

`HasEltype()` is the default, since iterators are assumed to implement [`eltype`](@ref).

This trait is generally used to select between algorithms that pre-allocate a specific type of result, and algorithms that pick a result type based on the types of yielded values.

```jldoctest
julia> Base.IteratorEltype(1:5)
Base.HasEltype()
```
