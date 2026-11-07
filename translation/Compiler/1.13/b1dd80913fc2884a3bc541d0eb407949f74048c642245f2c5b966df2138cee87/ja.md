```julia
walk_to_defs(compact, val, typeconstraint, predecessors)
```

`val`からuse-defチェーンをたどり、この`val`に値を供給するすべての葉を取得します（パス条件によって除外される葉は取り除きます）。

`predecessors(def, compact)`は、「phiのような」ノード（PhiNodeまたはCore.ifelse）の場合は可能な先行ノードの集合を、それ以外の場合は`nothing`を返すコールバックです。
