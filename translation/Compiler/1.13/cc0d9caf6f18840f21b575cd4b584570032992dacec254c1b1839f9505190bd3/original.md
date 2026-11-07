```julia
du::SSADefUse
```

This struct keeps track of all uses of some mutable struct allocated in the current function:

  * `du.uses::Vector{SSAUse}` are some "usages" (like `getfield`) of the struct
  * `du.defs::Vector{Int}` are all instances of `setfield!` on the struct

The terminology refers to the uses/defs of the "slot bundle" that the mutable struct represents.

`du.uses` tracks all instances of `getfield` and `isdefined` calls on the struct. Additionally it also tracks all instances of a `:foreigncall` that preserves of this mutable struct. Somewhat counterintuitively, we don't actually need to make sure that the struct itself is live (or even allocated) at a `ccall` site. If there are no other places where the struct escapes (and thus e.g. where its address is taken), it need not be allocated. We do however, need to make sure to preserve any elements of this struct.
