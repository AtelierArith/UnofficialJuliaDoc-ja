```julia
llvmcall(fun_ir::String, returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_ir::String, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
llvmcall((mod_bc::Vector{UInt8}, entry_fn::String), returntype, Tuple{argtype1, ...}, argvalue1, ...)
```

Call the LLVM code provided in the first argument. There are several ways to specify this first argument:

  * as a literal string, representing function-level IR (similar to an LLVM `define` block), with arguments are available as consecutive unnamed SSA variables (%0, %1, etc.);
  * as a 2-element tuple, containing a string of module IR and a string representing the name of the entry-point function to call;
  * as a 2-element tuple, but with the module provided as an `Vector{UInt8}` with bitcode.

Note that contrary to `ccall`, the argument types must be specified as a tuple type, and not a tuple of types. All types, as well as the LLVM code, should be specified as literals, and not as variables or expressions (it may be necessary to use `@eval` to generate these literals).

[Opaque pointers](https://llvm.org/docs/OpaquePointers.html) (written as `ptr`) are not allowed in the LLVM code.

See [`test/llvmcall.jl`](https://github.com/JuliaLang/julia/blob/v1.12.1/test/llvmcall.jl) for usage examples.
