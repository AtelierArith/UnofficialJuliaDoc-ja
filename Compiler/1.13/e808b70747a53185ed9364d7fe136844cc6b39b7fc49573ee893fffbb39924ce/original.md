```julia
inf_params::InferenceParams
```

Parameters that control abstract interpretation-based type inference operation.

---

  * `inf_params.max_methods::Int = 3`
    Type inference gives up analysis on a call when there are more than `max_methods` matching methods. This trades off between compiler latency and generated code performance. Typically, considering many methods means spending *lots* of time obtaining poor type information, so this option should be kept low. [`Base.Experimental.@max_methods`](@ref) can have a more fine-grained control on this configuration with per-module or per-method annotation basis.

---

  * `inf_params.max_union_splitting::Int = 4`
    Specifies the maximum number of union-tuples to swap or expand before computing the set of matching methods or conditional types.

---

  * `inf_params.max_apply_union_enum::Int = 8`
    Specifies the maximum number of union-tuples to swap or expand when inferring a call to `Core._apply_iterate`.

---

  * `inf_params.max_tuple_splat::Int = 32`
    When attempting to infer a call to `Core._apply_iterate`, abort the analysis if the tuple contains more than this many elements.

---

  * `inf_params.tuple_complexity_limit_depth::Int = 3`
    Specifies the maximum depth of large tuple type that can appear as specialized method signature when inferring a recursive call graph.

---

  * `inf_params.ipo_constant_propagation::Bool = true`
    If `false`, disables analysis with extended lattice information, i.e. disables any of the concrete evaluation, semi-concrete interpretation and constant propagation entirely. [`Base.@constprop :none`](@ref Base.@constprop) can have a more fine-grained control on this configuration with per-method annotation basis.

---

  * `inf_params.aggressive_constant_propagation::Bool = false`
    If `true`, forces constant propagation on any methods when any extended lattice information available. [`Base.@constprop :aggressive`](@ref Base.@constprop) can have a more fine-grained control on this configuration with per-method annotation basis.

---

  * `inf_params.assume_bindings_static::Bool = false`
    If `true`, assumes that no new bindings will be added, i.e. a non-existing binding at inference time can be assumed to always not exist at runtime (and thus e.g. any access to it will `throw`). Defaults to `false` since this assumption does not hold in Julia's semantics for native code execution.

---

  * `inf_params.force_enable_inference::Bool = false`
    If `true`, inference will be performed on functions regardless of whether it was disabled at the module level via `Base.Experimental.@compiler_options`.

---
