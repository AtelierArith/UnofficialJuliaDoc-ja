```julia
detect_unbound_args(mod1, mod2...; recursive=false, allowed_undefineds=nothing)
```

Return a vector of `Method`s which may have unbound type parameters. Use `recursive=true` to test in all submodules.

By default, any undefined symbols trigger a warning. This warning can be suppressed by supplying a collection of `GlobalRef`s for which the warning can be skipped. For example, setting

```julia
allowed_undefineds = Set([GlobalRef(Base, :active_repl),
                          GlobalRef(Base, :active_repl_backend)])
```

would suppress warnings about `Base.active_repl` and `Base.active_repl_backend`.

!!! compat "Julia 1.8"
    `allowed_undefineds` requires at least Julia 1.8.

