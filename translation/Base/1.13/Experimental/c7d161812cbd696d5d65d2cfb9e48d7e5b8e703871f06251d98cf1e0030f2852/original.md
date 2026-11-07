```julia
Experimental.@max_methods n::Int
```

Set the maximum number of potentially-matching methods considered when running inference for methods defined in the current module. This setting affects inference of calls with incomplete knowledge of the argument types.

The benefit of this setting is to avoid excessive compilation and reduce invalidation risks in poorly-inferred cases. For example, when `@max_methods 2` is set and there are two potentially-matching methods returning different types inside a function body, then Julia will compile subsequent calls for both types so that the compiled function body accounts for both possibilities. Also the compiled code is vulnerable to invalidations that would happen when either of the two methods gets invalidated. This speculative compilation and these invalidations can be avoided by setting `@max_methods 1` and allowing the compiled code to resort to runtime dispatch instead.

Supported values are `1`, `2`, `3`, `4`, and `default` (currently equivalent to `3`).
