```julia
peel(iter)
```

Returns the first element and an iterator over the remaining elements.

If the iterator is empty return `nothing` (like `iterate`).

!!! compat "Julia 1.7"
    Prior versions throw a BoundsError if the iterator is empty.


See also: [`Iterators.drop`](@ref), [`Iterators.take`](@ref).

# Examples

```jldoctest
julia> (a, rest) = Iterators.peel("abc");

julia> a
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> collect(rest)
2-element Vector{Char}:
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
```
