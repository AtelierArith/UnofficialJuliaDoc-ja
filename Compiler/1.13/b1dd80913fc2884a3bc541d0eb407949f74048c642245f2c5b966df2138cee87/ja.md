```julia
walk_to_defs(compact, val, typeconstraint, predecessors)
```

`val` から use-def チェーンをたどり、この `val` に値を供給するすべての葉を取得します（パス条件によって除外される葉は取り除きます）。

`predecessors(def, compact)` はコールバックです。「phi のような」ノード（PhiNode または Core.ifelse）に対しては、可能な先行ノードの集合を返し、それ以外の場合は `nothing` を返します。
