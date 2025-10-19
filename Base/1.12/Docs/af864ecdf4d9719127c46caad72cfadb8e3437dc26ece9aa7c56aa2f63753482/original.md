```julia
@__doc__(ex)
```

Low-level macro used to mark expressions returned by a macro that should be documented. If more than one expression is marked then the same docstring is applied to each expression.

```julia
macro example(f)
    quote
        $(f)() = 0
        @__doc__ $(f)(x) = 1
        $(f)(x, y) = 2
    end |> esc
end
```

`@__doc__` has no effect when a macro that uses it is not documented.

!!! compat "Julia 1.12"
    This section documents a very subtle corner case that is only relevant to macros which themselves both define other macros and then attempt to use them within the same expansion. Such macros were impossible to write prior to Julia 1.12 and are still quite rare. If you are not writing such a macro, you may ignore this note.

    In versions prior to Julia 1.12, macroexpansion would recursively expand through `Expr(:toplevel)` blocks. This behavior was changed in Julia 1.12 to allow macros to recursively define other macros and use them in the same returned expression. However, to preserve backwards compatibility with existing uses of `@__doc__`, the doc system will still expand through `Expr(:toplevel)` blocks when looking for `@__doc__` markers. As a result, macro-defining-macros will have an observable behavior difference when annotated with a docstring:

    ```julia
    julia> macro macroception()
        Expr(:toplevel, :(macro foo() 1 end), :(@foo))
    end

    julia> @macroception
    1

    julia> "Docstring" @macroception
    ERROR: LoadError: UndefVarError: `@foo` not defined in `Main`
    ```

    The supported workaround is to manually expand the `@__doc__` macro in the defining macro, which the docsystem will recognize and suppress the recursive expansion:

    ```julia
    julia> macro macroception()
        Expr(:toplevel,
            macroexpand(__module__, :(@__doc__ macro foo() 1 end); recursive=false),
            :(@foo))
    end

    julia> @macroception
    1

    julia> "Docstring" @macroception
    1
    ```

