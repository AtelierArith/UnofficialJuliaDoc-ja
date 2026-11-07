```julia
compute_frameinfo(ir::IRCode) -> tryregions
```

`ir` に対するエスケープ解析の前に行う準備的な線形スキャン。`tryregions::Union{Nothing,Vector{UnitRange{Int}}}` を見つけます。これらは、潜在的な `throw` を捕捉できる領域を表します（`escape_exception!` で使用）。
