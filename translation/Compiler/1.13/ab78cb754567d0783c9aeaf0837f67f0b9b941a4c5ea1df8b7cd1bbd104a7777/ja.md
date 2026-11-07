```julia
builtin_effects(𝕃::AbstractLattice, f::Builtin, argtypes::Vector{Any}, rt)::Effects
```

組み込み関数呼び出しのエフェクトを計算します。`argtypes`には、`f`自体を含めないでください。
