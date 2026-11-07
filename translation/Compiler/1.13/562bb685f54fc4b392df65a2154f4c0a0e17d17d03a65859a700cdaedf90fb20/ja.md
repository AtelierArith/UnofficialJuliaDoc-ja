```julia
is_lattice_equal(𝕃::AbstractLattice, a, b)::Bool
```

2つの束要素が半順序同値かどうかを確認します。基本的には、`a ⊑ b && b ⊑ a` を `𝕃` の束で行う処理ですが、必要に応じてパフォーマンスを最適化できます。
