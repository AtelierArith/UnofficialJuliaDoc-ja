```julia
postdominates(domtree::PostDomTree, bb1::Int, bb2::Int)::Bool
```

`bb1`が`bb2`をポストドミネートするかどうかを判定します。`bb1`と`bb2`は、`CFG`ブロック内のインデックスです。`bb1`が`bb2`をポストドミネートするのは、`bb2`から出口までのすべての経路が`bb1`を経由する場合です（途中にほかのブロックが入ることもあります。例：`bb2->bbx->bb1->exit`）。
