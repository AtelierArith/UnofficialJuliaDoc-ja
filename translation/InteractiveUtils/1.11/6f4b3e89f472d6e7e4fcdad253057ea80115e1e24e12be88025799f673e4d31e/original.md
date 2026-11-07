```julia
edit(function, [types])
edit(module)
```

Edit the definition of a function, optionally specifying a tuple of types to indicate which method to edit. For modules, open the main source file. The module needs to be loaded with `using` or `import` first.

!!! compat "Julia 1.1"
    `edit` on modules requires at least Julia 1.1.


To ensure that the file can be opened at the given line, you may need to call `InteractiveUtils.define_editor` first.
