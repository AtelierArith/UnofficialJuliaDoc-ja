```julia
@code_typed
```

Evaluates the arguments to the function or macro call, determines their types, and calls [`code_typed`](@ref) on the resulting expression. Use the optional argument `optimize` with

```julia
@code_typed optimize=true foo(x)
```

to control whether additional optimizations, such as inlining, are also applied.

See also: [`code_typed`](@ref), [`@code_warntype`](@ref), [`@code_lowered`](@ref), [`@code_llvm`](@ref), [`@code_native`](@ref).
