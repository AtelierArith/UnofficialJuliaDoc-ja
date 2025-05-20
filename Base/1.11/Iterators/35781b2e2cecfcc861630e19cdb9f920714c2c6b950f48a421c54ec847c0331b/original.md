```
only(x)
```

Return the one and only element of collection `x`, or throw an [`ArgumentError`](@ref) if the collection has zero or multiple elements.

See also [`first`](@ref), [`last`](@ref).

!!! compat "Julia 1.4"
    This method requires at least Julia 1.4.


# Examples

```jldoctest
julia> only(["a"])
"a"

julia> only("a")
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> only(())
ERROR: ArgumentError: Tuple contains 0 elements, must contain exactly 1 element
Stacktrace:
[...]

julia> only(('a', 'b'))
ERROR: ArgumentError: Tuple contains 2 elements, must contain exactly 1 element
Stacktrace:
[...]
```
