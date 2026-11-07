```julia
info::ReturnTypeCallInfo <: CallInfo
```

Represents a resolved call of `Core.Compiler.return_type`. `info.call` wraps the info corresponding to the call that `Core.Compiler.return_type` call was supposed to analyze.
