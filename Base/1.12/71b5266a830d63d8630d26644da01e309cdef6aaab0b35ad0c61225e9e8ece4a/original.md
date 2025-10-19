```julia
==(x, y)
```

Generic equality operator. Falls back to [`===`](@ref). Should be implemented for all types with a notion of equality, based on the abstract value that an instance represents. For example, all numeric types are compared by numeric value, ignoring type. Strings are compared as sequences of characters, ignoring encoding. Collections of the same type generally compare their key sets, and if those are `==`, then compare the values for each of those keys, returning true if all such pairs are `==`. Other properties are typically not taken into account (such as the exact type).

This operator follows IEEE semantics for floating-point numbers: `0.0 == -0.0` and `NaN != NaN`.

The result is of type `Bool`, except when one of the operands is [`missing`](@ref), in which case `missing` is returned ([three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic)). Collections generally implement three-valued logic akin to [`all`](@ref), returning missing if any operands contain missing values and all other pairs are equal. Use [`isequal`](@ref) or [`===`](@ref) to always get a `Bool` result.

# Implementation

New numeric types should implement this function for two arguments of the new type, and handle comparison to other types via promotion rules where possible.

Equality and hashing are intimately related; two values that are considered [`isequal`](@ref) **must** have the same [`hash`](@ref) and by default `isequal` falls back to `==`. If a type customizes the behavior of `==` and/or [`isequal`](@ref), then [`hash`](@ref) must be similarly implemented to ensure `isequal` and `hash` agree. `Set`s, `Dict`s, and many other internal implementations assume that this invariant holds.

If some type defines `==`, [`isequal`](@ref), and [`isless`](@ref) then it should also implement [`<`](@ref) to ensure consistency of comparisons.
