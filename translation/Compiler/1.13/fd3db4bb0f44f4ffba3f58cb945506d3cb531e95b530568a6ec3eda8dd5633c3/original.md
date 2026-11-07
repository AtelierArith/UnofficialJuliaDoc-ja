```julia
dominates(domtree::DomTree, bb1::Int, bb2::Int)::Bool
```

Checks if `bb1` dominates `bb2`. `bb1` and `bb2` are indexes into the `CFG` blocks. `bb1` dominates `bb2` if the only way to enter `bb2` is via `bb1`. (Other blocks may be in between, e.g `bb1->bbx->bb2`).
