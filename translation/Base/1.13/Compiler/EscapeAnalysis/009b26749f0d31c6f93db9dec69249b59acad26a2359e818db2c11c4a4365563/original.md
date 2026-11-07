```julia
from_interprocedural(argescape::ArgEscapeInfo, pc::Int) -> x::EscapeInfo
```

Reinterprets the escape information imposed on the call argument which is cached as `argescape` in the context of the caller frame, where `pc` is the SSA statement number of the return value.
