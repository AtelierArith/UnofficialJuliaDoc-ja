```julia
from_interprocedural!(interp::AbstractInterpreter, rt, sv::AbsIntState,
                      arginfo::ArgInfo, maybecondinfo) -> newrt
```

Converts inter-procedural return type `rt` into a local lattice element `newrt`, that is appropriate in the context of current local analysis frame `sv`, especially:

  * unwraps `rt::LimitedAccuracy` and collects its limitations into the current frame `sv`
  * converts boolean `rt` to new boolean `newrt` in a way `newrt` can propagate extra conditional refinement information, e.g. translating `rt::InterConditional` into `newrt::Conditional` that holds a type constraint information about a variable in `sv`

This function *should* be used wherever we propagate results returned from `abstract_call_method` or `abstract_call_method_with_const_args`.

When `maybecondinfo !== nothing`, this function also tries extra conditional argument type refinement. In such cases `maybecondinfo` should be either of:

  * `maybecondinfo::Tuple{Vector{Any},Vector{Any}}`: precomputed argument type refinement information
  * method call signature tuple type

When we deal with multiple `MethodMatch`es, it's better to precompute `maybecondinfo` by `tmerge`ing argument signature type of each method call.
