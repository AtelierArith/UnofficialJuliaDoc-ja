```julia
ccall_macro_parse(expression)
```

`ccall_macro_parse` is an implementation detail of `@ccall`.

It takes an expression like `:(printf("%d"::Cstring, value::Cuint)::Cvoid)` returns: a tuple of `(function_name, return_type, arg_types, args)`

The above input outputs this:

```julia
(:printf, :Cvoid, [:Cstring, :Cuint], ["%d", :value])
```
