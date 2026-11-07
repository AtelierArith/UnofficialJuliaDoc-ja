```julia
is_lattice_equal(𝕃::AbstractLattice, a, b)::Bool
```

2つの格子要素が半順序同値かどうかを確認します。基本的には、`𝕃`の格子における`a ⊑ b && b ⊑ a`ですが、パフォーマンスを向上させる最適化を追加することもできます。
