```julia
typeinf_ircode(interp::AbstractInterpreter, match::MethodMatch,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
typeinf_ircode(interp::AbstractInterpreter,
               method::Method, atype, sparams::SimpleVector,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
typeinf_ircode(interp::AbstractInterpreter, mi::MethodInstance,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
```

Infer a `method` and return an `IRCode` with inferred `returntype` on success.
