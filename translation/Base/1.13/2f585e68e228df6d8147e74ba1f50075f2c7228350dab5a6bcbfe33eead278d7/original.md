```julia
inferencebarrier(x)
```

A shorthand for `compilerbarrier(:type, x)` causes the type of this statement to be inferred as `Any`. See [`Base.compilerbarrier`](@ref) for more info.
