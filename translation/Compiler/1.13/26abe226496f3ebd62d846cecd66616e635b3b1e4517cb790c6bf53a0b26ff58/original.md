```julia
is_mutation_free_argtype(argtype)::Bool
```

Return `true` if `argtype` object is mutation free in the sense that no mutable memory is reachable from this type (either in the type itself) or through any fields (see `Base.ismutationfree`). This query is specifically written for analyzing the `:inaccessiblememonly` effect property and is supposed to improve the analysis accuracy by not tainting the `:inaccessiblememonly` property when there is access to mutation-free global object.
