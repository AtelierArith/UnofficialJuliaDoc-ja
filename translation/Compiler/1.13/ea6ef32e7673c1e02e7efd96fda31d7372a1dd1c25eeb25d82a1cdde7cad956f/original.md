```julia
iterated_dominance_frontier(cfg::CFG, liveness::BlockLiveness, domtree::DomTree)
    -> phinodes::Vector{Int}
```

Run iterated dominance frontier. The algorithm we have here essentially follows LLVM, which itself is a a cleaned up version of the linear-time algorithm described in [^SG95].

The algorithm here is quite straightforward. Suppose we have a CFG:

```julia
A -> B -> D -> F
 \-> C ------>/
```

and a corresponding dominator tree:

```julia
A
|- B - D
|- C
|- F
```

Now, for every definition of our slot, we simply walk down the dominator tree and look for any edges that leave the sub-domtree rooted by our definition.

In our example above, if we have a definition in `B`, we look at its successors, which is only `D`, which is dominated by `B` and hence doesn't need a ϕ-node. Then we descend down the subtree rooted at `B` and end up in `D`. `D` has a successor `F`, which is not part of the current subtree, (i.e. not dominated by `B`), so it needs a ϕ-node.

Now, the key insight of that algorithm is that we have two defs, in blocks `A` and `B`, and `A` dominates `B`, then we do not need to recurse into `B`, because the set of potential backedges from a subtree rooted at `B` (to outside the subtree) is a strict subset of those backedges from a subtree rooted at `A` (out outside the subtree rooted at `A`). Note however that this does not work the other way. Thus, the algorithm needs to make sure that we always visit `B` before `A`.

[^SG95]: Vugranam C. Sreedhar and Guang R. Gao. 1995.      A linear time algorithm for placing φ-nodes.      In Proceedings of the 22nd ACM SIGPLAN-SIGACT symposium on Principles of programming languages (POPL '95).      Association for Computing Machinery, New York, NY, USA, 62–73.      DOI: ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)](https://doi.org/10.1145/199448.199464).
