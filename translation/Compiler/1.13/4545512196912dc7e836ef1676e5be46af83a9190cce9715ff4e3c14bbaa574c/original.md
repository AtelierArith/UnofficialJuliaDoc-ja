```julia
finishopt!(interp::AbstractInterpreter, opt::OptimizationState, ir::IRCode)
```

Called at the end of optimization to store the resulting IR back into the OptimizationState.
