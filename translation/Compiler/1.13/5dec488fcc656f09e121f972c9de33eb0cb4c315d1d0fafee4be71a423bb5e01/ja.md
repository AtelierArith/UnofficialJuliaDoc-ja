```julia
typeinf_ircode(interp::AbstractInterpreter, match::MethodMatch,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
typeinf_ircode(interp::AbstractInterpreter,
               method::Method, atype, sparams::SimpleVector,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
typeinf_ircode(interp::AbstractInterpreter, mi::MethodInstance,
               optimize_until::Union{Int,String,Nothing}) -> (ir::Union{IRCode,Nothing}, returntype::Type)
```

`method`を推論し、成功した場合は推論した`returntype`を含む`IRCode`を返します。
