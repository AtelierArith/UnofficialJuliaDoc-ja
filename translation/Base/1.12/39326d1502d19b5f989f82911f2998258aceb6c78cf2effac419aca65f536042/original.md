```julia
@main
```

This macro is used to mark that the binding `main` in the current module is considered an entrypoint. The precise semantics of the entrypoint depend on the CLI driver.

In the `julia` driver, if `Main.main` is marked as an entrypoint, it will be automatically called upon the completion of script execution.

The `@main` macro may be used standalone or as part of the function definition, though in the latter case, parentheses are required. In particular, the following are equivalent:

```julia
function @main(args)
    println("Hello World")
end
```

```julia
function main(args)
end
@main
```

## Detailed semantics

The entrypoint semantics attach to the owner of the binding owner. In particular, if a marked entrypoint is imported into `Main`, it will be treated as an entrypoint in `Main`:

```julia
module MyApp
    export main
    @main(args) = println("Hello World")
end
using .MyApp
# `julia` Will execute MyApp.main at the conclusion of script execution
```

Note that in particular, the semantics do not attach to the method or the name:

```julia
module MyApp
    @main(args) = println("Hello World")
end
const main = MyApp.main
# `julia` Will *NOT* execute MyApp.main unless there is a separate `@main` annotation in `Main`
```

!!! compat "Julia 1.11"
    This macro is new in Julia 1.11. At present, the precise semantics of `@main` are still subject to change.

