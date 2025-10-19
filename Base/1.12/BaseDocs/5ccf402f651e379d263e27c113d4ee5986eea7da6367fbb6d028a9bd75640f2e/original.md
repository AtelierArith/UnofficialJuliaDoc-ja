```julia
using
```

`using Foo` will load the module or package `Foo` and make its [`export`](@ref)ed names available for direct use. Names can also be used via dot syntax (e.g. `Foo.foo` to access the name `foo`), whether they are `export`ed or not. See the [manual section about modules](@ref modules) for details.

!!! note
    When two or more packages/modules export a name and that name does not refer to the same thing in each of the packages, and the packages are loaded via `using` without an explicit list of names, it is an error to reference that name without qualification. It is thus recommended that code intended to be forward-compatible with future versions of its dependencies and of Julia, e.g., code in released packages, list the names it uses from each loaded package, e.g., `using Foo: Foo, f` rather than `using Foo`.

