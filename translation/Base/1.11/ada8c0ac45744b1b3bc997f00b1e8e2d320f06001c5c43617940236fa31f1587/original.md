```
@assert cond [text]
```

Throw an [`AssertionError`](@ref) if `cond` is `false`. This is the preferred syntax for writing assertions, which are conditions that are assumed to be true, but that the user might decide to check anyways, as an aid to debugging if they fail. The optional message `text` is displayed upon assertion failure.

!!! warning
    An assert might be disabled at some optimization levels. Assert should therefore only be used as a debugging tool and not used for authentication verification (e.g., verifying passwords or checking array bounds). The code must not rely on the side effects of running `cond` for the correct behavior of a function.


# Examples

```jldoctest
julia> @assert iseven(3) "3 is an odd number!"
ERROR: AssertionError: 3 is an odd number!

julia> @assert isodd(3) "What even are numbers?"
```
