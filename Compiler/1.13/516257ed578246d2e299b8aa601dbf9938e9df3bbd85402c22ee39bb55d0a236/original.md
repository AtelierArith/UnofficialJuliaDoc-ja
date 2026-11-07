```julia
inflate_ir(ci::CodeInfo) -> ir::IRCode
inflate_ir(ci::CodeInfo, mi::MethodInstance) -> ir::IRCode
inflate_ir(ci::CodeInfo, argtypes::Vector{Any}) -> ir::IRCode
inflate_ir(ci::CodeInfo, sptypes::Vector{VarState}, argtypes::Vector{Any}) -> ir::IRCode
```

Non-destructive version of `inflate_ir!`. Mainly used for testing or interactive use.
