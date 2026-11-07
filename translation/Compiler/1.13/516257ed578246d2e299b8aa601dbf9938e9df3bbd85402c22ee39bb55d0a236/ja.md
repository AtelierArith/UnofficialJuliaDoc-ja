```julia
inflate_ir(ci::CodeInfo) -> ir::IRCode
inflate_ir(ci::CodeInfo, mi::MethodInstance) -> ir::IRCode
inflate_ir(ci::CodeInfo, argtypes::Vector{Any}) -> ir::IRCode
inflate_ir(ci::CodeInfo, sptypes::Vector{VarState}, argtypes::Vector{Any}) -> ir::IRCode
```

`inflate_ir!`の非破壊版です。主にテストや対話的な使用に用いられます。
