```julia
lower_identifier_name(name, kind)
```

Lower a Julia identifier `name` of given `kind` to the name used by the Julia runtime. (In particular, this handles the name mangling of macros.)

This is a lowering (rather than parsing) step, but is needed for `Expr` conversion and is also used for pretty printing.
