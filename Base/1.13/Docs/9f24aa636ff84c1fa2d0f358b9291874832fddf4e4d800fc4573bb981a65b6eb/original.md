```julia
Docs.doc(binding, sig)
```

Return all documentation that matches both `binding` and `sig`.

If `getdoc` returns a non-`nothing` result on the value of the binding, then a dynamic docstring is returned instead of one based on the binding itself.

!!! compat "Julia 1.11"
    In Julia 1.11 and newer, `Docs.doc` requires that the `REPL` stdlib is loaded.

