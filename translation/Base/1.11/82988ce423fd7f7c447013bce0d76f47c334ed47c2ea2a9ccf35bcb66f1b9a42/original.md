```
@macroexpand [mod,] ex
```

Return equivalent expression with all macros removed (expanded). If two arguments are provided, the first is the module to evaluate in.

There are differences between `@macroexpand` and [`macroexpand`](@ref).

  * While [`macroexpand`](@ref) takes a keyword argument `recursive`, `@macroexpand` is always recursive. For a non recursive macro version, see [`@macroexpand1`](@ref).
  * While [`macroexpand`](@ref) has an explicit `module` argument, `@macroexpand` always expands with respect to the module in which it is called.

This is best seen in the following example:

```julia-repl
julia> module M
           macro m()
               1
           end
           function f()
               (@macroexpand(@m),
                macroexpand(M, :(@m)),
                macroexpand(Main, :(@m))
               )
           end
       end
M

julia> macro m()
           2
       end
@m (macro with 1 method)

julia> M.f()
(1, 1, 2)
```

With `@macroexpand` the expression expands where `@macroexpand` appears in the code (module `M` in the example). With `macroexpand` the expression expands in the module given as the first argument.

!!! compat "Julia 1.11"
    The two-argument form requires at least Julia 1.11.

