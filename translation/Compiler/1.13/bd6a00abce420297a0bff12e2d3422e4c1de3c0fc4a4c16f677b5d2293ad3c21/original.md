Remove from `cfg` and `reach` the edge (from → to), as well as any blocks/edges this causes to become unreachable.

Calls:

  * `block_callback` for every unreachable block.
  * `edge_callback` for every unreachable edge into a reachable block (may also  be called for blocks which are later discovered to be unreachable).
