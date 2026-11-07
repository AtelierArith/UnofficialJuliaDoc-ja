```julia
dominates(domtree::DomTree, bb1::Int, bb2::Int)::Bool
```

`bb1` が `bb2` を支配するかどうかを判定します。`bb1` と `bb2` は、`CFG` ブロック内のインデックスです。`bb1` が `bb2` を支配するのは、`bb2` に入る唯一の経路が `bb1` を経由する場合です（間にほかのブロックが入ることもあります。例：`bb1->bbx->bb2`）。
