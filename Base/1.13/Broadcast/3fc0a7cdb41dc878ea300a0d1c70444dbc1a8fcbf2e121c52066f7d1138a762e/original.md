```julia
newindex(argument, I)
newindex(I, keep, default)
```

Recompute index `I` such that it appropriately constrains broadcasted dimensions to the source.

Two methods are supported, both allowing for `I` to be specified as either a [`CartesianIndex`](@ref) or an `Int`.

  * `newindex(argument, I)` dynamically constrains `I` based upon the axes of `argument`.
  * `newindex(I, keep, default)` constrains `I` using the pre-computed tuples `keeps` and `defaults`.

      * `keep` is a tuple of `Bool`s, where `keep[d] == true` means that dimension `d` in `I` should be preserved as is
      * `default` is a tuple of Integers, specifying what index to use in dimension `d` when `keep[d] == false`.

    Any remaining indices in `I` beyond the length of the `keep` tuple are truncated. The `keep` and `default`   tuples may be created by `newindexer(argument)`.
