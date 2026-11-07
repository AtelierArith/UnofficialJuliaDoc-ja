```julia
@ccallable ["name"] function f(...)::RetType ... end
```

Make the annotated function be callable from C using its name. This can, for example, be used to expose functionality as a C API when creating a custom Julia sysimage.

If the first argument is a string, it is used as the external name of the function.
