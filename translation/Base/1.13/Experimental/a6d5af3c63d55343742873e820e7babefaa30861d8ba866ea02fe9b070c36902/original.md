```julia
Experimental.@max_methods n::Int function fname end
```

Set the maximum number of potentially-matching methods considered when running inference for the generic function `fname`. Overrides any module-level or global inference settings for max_methods. This setting is global for the entire generic function (or more precisely the MethodTable).
