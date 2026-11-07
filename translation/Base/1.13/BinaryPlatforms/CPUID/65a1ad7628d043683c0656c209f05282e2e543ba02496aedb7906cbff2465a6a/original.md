```julia
ISA(features::Set{UInt32})
```

A structure which represents the Instruction Set Architecture (ISA) of a computer.  It holds the `Set` of features of the CPU.

The numerical values of the features are automatically generated from the C source code of Julia and stored in the `features_h.jl` Julia file.
