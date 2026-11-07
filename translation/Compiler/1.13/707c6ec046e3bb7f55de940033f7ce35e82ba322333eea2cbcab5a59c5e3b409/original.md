```julia
postdominates(domtree::PostDomTree, bb1::Int, bb2::Int)::Bool
```

Checks if `bb1` post-dominates `bb2`. `bb1` and `bb2` are indexes into the `CFG` blocks. `bb1` post-dominates `bb2` if every pass from `bb2` to the exit is via `bb1`. (Other blocks may be in between, e.g `bb2->bbx->bb1->exit`).
