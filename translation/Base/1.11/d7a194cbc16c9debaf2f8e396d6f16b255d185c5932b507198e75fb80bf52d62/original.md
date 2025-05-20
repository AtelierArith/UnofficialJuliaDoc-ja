```
collect(collection)
```

Return an `Array` of all items in a collection or iterator. For dictionaries, returns a `Vector` of `key=>value` [Pair](@ref Pair)s. If the argument is array-like or is an iterator with the [`HasShape`](@ref IteratorSize) trait, the result will have the same shape and number of dimensions as the argument.

Used by [comprehensions](@ref man-comprehensions) to turn a [generator expression](@ref man-generators) into an `Array`. Thus, *on generators*, the square-brackets notation may be used instead of calling `collect`, see second example.

# Examples

Collect items from a `UnitRange{Int64}` collection:

```jldoctest
julia> collect(1:3)
3-element Vector{Int64}:
 1
 2
 3
```

Collect items from a generator (same output as `[x^2 for x in 1:3]`):

```jldoctest
julia> collect(x^2 for x in 1:3)
3-element Vector{Int64}:
 1
 4
 9
```
