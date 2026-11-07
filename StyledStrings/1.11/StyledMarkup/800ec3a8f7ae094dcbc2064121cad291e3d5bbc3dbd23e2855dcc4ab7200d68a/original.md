```julia
hygienic_eval(state::State, expr)
```

Evaluate `expr` within the scope of `state`'s module. This replicates part of the behind-the-scenes behaviour of macro expansion, we just need to manually invoke it due to the particularities around dealing with code from a foreign module that we parse ourselves.
