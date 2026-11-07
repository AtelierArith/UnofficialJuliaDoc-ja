```julia
finishopt!(interp::AbstractInterpreter, opt::OptimizationState, ir::IRCode)
```

最適化の最後に呼び出され、最適化後の IR を OptimizationState に格納します。
