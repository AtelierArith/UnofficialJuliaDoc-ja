```julia
@code_native
```

Evaluates the arguments to the function or macro call, determines their types, and calls [`code_native`](@ref) on the resulting expression.

Set any of the optional keyword arguments `syntax`, `debuginfo`, `binary` or `dump_module` by putting it before the function call, like this:

```julia
@code_native syntax=:intel debuginfo=:default binary=true dump_module=false f(x)
```

  * Set assembly syntax by setting `syntax` to `:intel` (default) for Intel syntax or `:att` for AT&T syntax.
  * Specify verbosity of code comments by setting `debuginfo` to `:source` (default) or `:none`.
  * If `binary` is `true`, also print the binary machine code for each instruction precedented by an abbreviated address.
  * If `dump_module` is `false`, do not print metadata such as rodata or directives.

See also: [`code_native`](@ref), [`@code_warntype`](@ref), [`@code_typed`](@ref), [`@code_lowered`](@ref), [`@code_llvm`](@ref).
