```julia
opt_params::OptimizationParams
```

Parameters that control optimizer operation.

---

  * `opt_params.inlining::Bool = inlining_enabled()`
    Controls whether or not inlining is enabled.

---

  * `opt_params.inline_cost_threshold::Int = 100`
    Specifies the number of CPU cycles beyond which it's not worth inlining.

---

  * `opt_params.inline_nonleaf_penalty::Int = 1000`
    Specifies the penalty cost for a dynamic dispatch.

---

  * `opt_params.inline_tupleret_bonus::Int = 250`
    Specifies the extra inlining willingness for a method specialization with non-concrete tuple return types (in hopes of splitting it up). `opt_params.inline_tupleret_bonus` will be added to `opt_params.inline_cost_threshold` when making inlining decision.

---

  * `opt_params.max_tuple_splat::Int = 32`
    When attempting to inline `Core._apply_iterate`, abort the optimization if the tuple contains more than this many elements.

---

  * `opt_params.compilesig_invokes::Bool = true`
    If `true`, gives the inliner license to change which `MethodInstance` to invoke when generating `:invoke` expression based on the [`@nospecialize`](@ref) annotation, in order to avoid over-specialization.

---

  * `opt_params.assume_fatal_throw::Bool = false`
    If `true`, gives the optimizer license to assume that any `throw` is fatal and thus the state after a `throw` is not externally observable. In particular, this gives the optimizer license to move side effects (that are proven not observed within a particular code path) across a throwing call. Defaults to `false`.

---

  * `opt_params.preserve_local_sources::Bool = false`
    If `true`, the inliner is restricted from modifying locally-cached sources that are retained in `CallInfo` objects and always makes their copies before inlining them into caller context. Defaults to `false`.

---
