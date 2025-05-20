```
isless(x, y)
```

Test whether `x` is less than `y`, according to a fixed total order (defined together with [`isequal`](@ref)). `isless` is not defined for pairs `(x, y)` of all types. However, if it is defined, it is expected to satisfy the following:

  * If `isless(x, y)` is defined, then so is `isless(y, x)` and `isequal(x, y)`, and exactly one of those three yields `true`.
  * The relation defined by `isless` is transitive, i.e., `isless(x, y) && isless(y, z)` implies `isless(x, z)`.

Values that are normally unordered, such as `NaN`, are ordered after regular values. [`missing`](@ref) values are ordered last.

This is the default comparison used by [`sort!`](@ref).

# Implementation

Non-numeric types with a total order should implement this function. Numeric types only need to implement it if they have special values such as `NaN`. Types with a partial order should implement [`<`](@ref). See the documentation on [Alternate Orderings](@ref) for how to define alternate ordering methods that can be used in sorting and related functions.

# Examples

```jldoctest
julia> isless(1, 3)
true

julia> isless("Red", "Blue")
false
```
