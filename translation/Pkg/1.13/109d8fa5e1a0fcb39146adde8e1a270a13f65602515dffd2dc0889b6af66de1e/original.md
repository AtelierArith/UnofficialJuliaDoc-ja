```julia
in_repl_mode()
```

Check if we're currently executing in REPL mode. This is used to determine whether to show tips in REPL format (`pkg> add Foo`) or API format (`Pkg.add("Foo")`).
