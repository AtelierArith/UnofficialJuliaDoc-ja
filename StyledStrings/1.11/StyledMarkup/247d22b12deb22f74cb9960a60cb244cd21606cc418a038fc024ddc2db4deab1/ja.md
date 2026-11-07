```julia
addpart!(state::State, start::Int, expr, stop::Int)
```

現在有効なスタイルを考慮し、`start`から`stop`までを対象に、`expr`（最終的な評価）に基づいて新しいパートを作成します。
