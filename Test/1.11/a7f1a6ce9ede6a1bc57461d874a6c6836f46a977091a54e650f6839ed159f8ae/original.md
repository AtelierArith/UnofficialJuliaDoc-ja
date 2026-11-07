```julia
detect_ambiguities(mod1, mod2...; recursive=false,
                                  ambiguous_bottom=false,
                                  allowed_undefineds=nothing)
```

Return a vector of `(Method,Method)` pairs of ambiguous methods defined in the specified modules. Use `recursive=true` to test in all submodules.

`ambiguous_bottom` controls whether ambiguities triggered only by `Union{}` type parameters are included; in most cases you probably want to set this to `false`. See [`Base.isambiguous`](@ref).

See [`Test.detect_unbound_args`](@ref) for an explanation of `allowed_undefineds`.

!!! compat "Julia 1.8"
    `allowed_undefineds` requires at least Julia 1.8.

