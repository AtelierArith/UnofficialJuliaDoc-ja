```julia
struct LimitedAccuracy
```

A `LimitedAccuracy` lattice element is used to indicate that the true inference result was approximate due to heuristic termination of a recursion. For example, consider two call stacks starting from `A` and `B` that look like:

```julia
A -> C -> A -> D
B -> C -> A -> D
```

In the first case, inference may have decided that `A->C->A` constitutes a cycle, widening the result it obtained for `C`, even if it might otherwise have been able to obtain a result. In this case, the result inferred for `C` will be annotated with this lattice type to indicate that the obtained result is an upper bound for the non-limited inference. In particular, this means that the call stack originating at `B` will re-perform inference without being poisoned by the potentially inaccurate result obtained during the inference of `A`.

N.B.: We do *not* take any efforts to ensure the reverse. For example, if `B` is inferred first, then we may cache a precise result for `C` and re-use this result while inferring `A`, even if inference of `A` would have not been able to obtain this result due to limiting. This is undesirable, because it makes some inference results order dependent, but there it is unclear how this situation could be avoided.

A `LimitedAccuracy` element wraps another lattice element (let's call it `T`) and additionally tracks the `causes` due to which limitation occurred. As a lattice element, `LimitedAccuracy(T)` is considered ε smaller than the corresponding lattice element `T`, but in particular, all lattice elements that are `⊑ T` (but not equal `T`) are also `⊑ LimitedAccuracy(T)`.

The `causes` list is used to determine whether a particular cause of limitation is inevitable and if so, widening `LimitedAccuracy(T)` back to `T`. For example, in the call stacks above, if any call to `A` always leads back to `A`, then it does not matter whether we start at `A` or reach it via `B`: Any inference that reaches `A` will always hit the same limitation and the result may thus be cached.
