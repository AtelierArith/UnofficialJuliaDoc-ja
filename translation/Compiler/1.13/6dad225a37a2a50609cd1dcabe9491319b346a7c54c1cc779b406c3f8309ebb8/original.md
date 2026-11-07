```julia
tarjan!(reach::CFGReachability, cfg::CFG, root::Int=1)
```

Tarjan's strongly-connected components algorithm. Traverses the CFG starting at `root`, ignoring nodes with resolved SCC's and updating outputs for all un-resolved nodes.

Returns true if any node was discovered to be unreachable, false otherwise.

Outputs:

  * `reach.scc`: strongly-connected components, ignoring backedges to (natural) loops
  * `reach.irreducible`: true iff a BasicBlock is part of a (non-trivial) SCC / irreducible loop
  * `reach._worklist`: if performing an incremental update (`root != 1`), any traversed nodes that are unreachable from BasicBlock #1 are enqueued to this worklist
