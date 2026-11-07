```julia
@isexpr(ex, head)
@isexpr(ex, head, nargs)
```

Type inference friendly replacement for `Meta.isexpr`.

When using the pattern

```julia
if @isexpr(ex, headsym)
    body
end
```

Julia's type inference knows `ex isa Expr` inside `body`. But `Meta.isexpr` hides this information from the compiler, for whatever reason.
