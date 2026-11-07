```julia
findall(sig::Type, view::MethodTableView; limit::Int=-1) ->
    matches::MethodLookupResult or nothing
```

Find all methods in the given method table `view` that are applicable to the given signature `sig`. If no applicable methods are found, an empty result is returned. If the number of applicable methods exceeded the specified `limit`, `nothing` is returned. Note that the default setting `limit=-1` does not limit the number of applicable methods. `overlayed` indicates if any of the matching methods comes from an overlayed method table.
