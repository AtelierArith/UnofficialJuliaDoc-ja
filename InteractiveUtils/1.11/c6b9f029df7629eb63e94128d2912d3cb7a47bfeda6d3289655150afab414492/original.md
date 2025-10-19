```julia
code_native([io=stdout,], f, types; syntax=:intel, debuginfo=:default, binary=false, dump_module=true)
```

Prints the native assembly instructions generated for running the method matching the given generic function and type signature to `io`.

  * Set assembly syntax by setting `syntax` to `:intel` (default) for intel syntax or `:att` for AT&T syntax.
  * Specify verbosity of code comments by setting `debuginfo` to `:source` (default) or `:none`.
  * If `binary` is `true`, also print the binary machine code for each instruction precedented by an abbreviated address.
  * If `dump_module` is `false`, do not print metadata such as rodata or directives.
  * If `raw` is `false`, uninteresting instructions (like the safepoint function prologue) are elided.

See also: [`@code_native`](@ref), [`code_warntype`](@ref), [`code_typed`](@ref), [`code_lowered`](@ref), [`code_llvm`](@ref).
