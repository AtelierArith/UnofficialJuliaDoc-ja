```julia
dominates(domtree::DomTree, bb1::Int, bb2::Int)::Bool
```

`bb1`が`bb2`を支配するかどうかを判定します。`bb1`と`bb2`は、`CFG`ブロック内のインデックスです。`bb1`が`bb2`を支配するのは、`bb2`に入る方法が`bb1`を経由する場合に限られるときです。（たとえば、間にほかのブロックが入ることもあります。`bb1->bbx->bb2`）
