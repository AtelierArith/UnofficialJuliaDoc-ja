```julia
may_invoke_generator(method, atype, sparams)::Bool
```

Computes whether or not we may invoke the generator for the given `method` on the given `atype` and `sparams`. For correctness, all generated function are required to return monotonic answers. However, since we don't expect users to be able to successfully implement this criterion, we only call generated functions on concrete types. The one exception to this is that we allow calling generators with abstract types if the generator does not use said abstract type (and thus cannot incorrectly use it to break monotonicity). This function computes whether we are in either of these cases.

Unlike normal functions, the compilation heuristics still can't generate good dispatch in some cases, but this may still allow inference not to fall over in some limited cases.
