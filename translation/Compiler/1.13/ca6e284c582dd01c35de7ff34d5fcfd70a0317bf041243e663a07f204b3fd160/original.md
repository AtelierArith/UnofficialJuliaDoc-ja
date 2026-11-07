```julia
findsup(sig::Type, view::MethodTableView) ->
    (match::Union{MethodMatch,Nothing}, valid_worlds::WorldRange, overlayed::Bool)
```

Find the (unique) method such that `sig <: match.method.sig`, while being more specific than any other method with the same property. In other words, find the method which is the least upper bound (supremum) under the specificity/subtype relation of the queried `sig`nature. If `sig` is concrete, this is equivalent to asking for the method that will be called given arguments whose types match the given signature. Note that this query is also used to implement `invoke`.

Such a matching method `match` doesn't necessarily exist. It is possible that no method is an upper bound of `sig`, or it is possible that among the upper bounds, there is no least element. In both cases `nothing` is returned.

`overlayed` indicates if any of the matching methods comes from an overlayed method table.
