```julia
esc(e)
```

Only valid in the context of an [`Expr`](@ref) returned from a macro. Prevents the macro hygiene pass from turning embedded variables into gensym variables. See the [Macros](@ref man-macros) section of the Metaprogramming chapter of the manual for more details and examples.
