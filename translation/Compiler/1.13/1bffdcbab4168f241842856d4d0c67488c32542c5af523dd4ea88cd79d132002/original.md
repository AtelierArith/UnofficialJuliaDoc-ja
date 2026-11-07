```julia
mutable struct TwoPhaseDefUseMap
```

This struct is intended as a memory- and GC-pressure-efficient mechanism for incrementally computing def-use maps. The idea is that the def-use map is constructed into two passes over the IR. In the first, we simply count the the number of uses, computing the number of uses for each def as well as the total number of uses. In the second pass, we actually fill in the def-use information.

The idea is that either of these two phases can be combined with other useful work that needs to scan the instruction stream anyway, while avoiding the significant allocation pressure of e.g. allocating an array for every SSA value or attempting to dynamically move things around as new uses are discovered.

The def-use map is presented as a vector of vectors. For every def, indexing into the map will return a vector of uses.
