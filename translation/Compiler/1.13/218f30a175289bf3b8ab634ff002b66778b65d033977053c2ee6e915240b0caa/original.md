```julia
inflate_ir!(ci::CodeInfo, mi::MethodInstance) -> ir::IRCode
inflate_ir!(ci::CodeInfo, sptypes::Vector{VarState}, argtypes::Vector{Any}) -> ir::IRCode
```

Inflates `ci::CodeInfo`-IR to `ir::IRCode`-format. This should be used with caution as it is a in-place transformation where the fields of the original `ci::CodeInfo` are modified.
