```julia
struct InferenceLattice{𝕃<:AbstractLattice} <: AbstractLattice
```

推論時の抽象解釈に使用される完全な束。基底束 `𝕃` を拡張し、`LimitedAccuracy` を追加します。
