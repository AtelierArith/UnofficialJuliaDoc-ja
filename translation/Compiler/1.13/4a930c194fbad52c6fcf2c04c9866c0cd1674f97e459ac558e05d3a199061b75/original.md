```julia
adce_pass!(ir::IRCode) -> newir::IRCode
```

Aggressive Dead Code Elimination pass.

In addition to a simple DCE for unused values and allocations, this pass also nullifies `typeassert` calls that can be proved to be no-op, in order to allow LLVM to emit simpler code down the road.

Note that this pass is more effective after SROA optimization (i.e. `sroa_pass!`), since SROA often allows this pass to:

  * eliminate allocation of object whose field references are all replaced with scalar values, and
  * nullify `typeassert` call whose first operand has been replaced with a scalar value (, which may have introduced new type information that inference did not understand)

Also note that currently this pass *needs* to run after `sroa_pass!`, because the `typeassert` elimination depends on the transformation by `canonicalize_typeassert!` done within `sroa_pass!` which redirects references of `typeassert`ed value to the corresponding `PiNode`.
