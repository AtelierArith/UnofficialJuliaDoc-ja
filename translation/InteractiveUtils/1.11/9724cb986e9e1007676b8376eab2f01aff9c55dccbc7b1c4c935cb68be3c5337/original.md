```julia
@activate Component
```

Activate a newly loaded copy of an otherwise builtin component. The `Component` to be activated will be resolved using the ordinary rules of module resolution in the current environment.

When using `@activate`, additional options for a component may be specified in square brackets `@activate Compiler[:option1, :option]`

Currently `@activate Compiler` is the only available component that may be activatived.

For `@activate Compiler`, the following options are available:

1. `:reflection` - Activate the compiler for reflection purposes only.                 The ordinary reflection functionality in `Base` and `InteractiveUtils`.                 Will use the newly loaded compiler. Note however, that these reflection                 functions will still interact with the ordinary native cache (both loading                 and storing). An incorrect compiler implementation may thus corrupt runtime                 state if reflection is used. Use external packages like `Cthulhu.jl`                 introspecting compiler behavior with a separated cache partition.
2. `:codegen`   - Activate the compiler for internal codegen purposes. The new compiler                will be invoked whenever the runtime requests compilation.

`@activate Compiler` without options is equivalent to `@activate Compiler[:reflection]`.
