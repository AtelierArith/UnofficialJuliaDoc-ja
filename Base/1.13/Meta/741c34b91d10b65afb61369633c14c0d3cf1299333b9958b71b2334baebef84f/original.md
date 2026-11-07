```julia
partially_inline!(code::Vector{Any}, slot_replacements::Vector{Any},
                  type_signature::Type{<:Tuple}, static_param_values::Vector{Any},
                  slot_offset::Int, statement_offset::Int,
                  boundscheck::Symbol)
```

Return `code` after performing an in-place partial inlining pass on the Julia IR stored within it.

The kind of inlining transformations performed by this function are those that are generally possible given only a runtime type signature for a method invocation and the corresponding method's lowered IR. Thus, this function is mainly useful when preparing Julia IR to be emitted from a `@generated` function.

The performed transformations are:

  * replace slot numbers in the range `1:length(slot_replacements)` with the corresponding items in `slot_replacements`
  * increment other slot numbers by `slot_offset`
  * substitute static parameter placeholders (e.g. `Expr(:static_parameter, 1)`) with the corresponding

values in `static_param_values`

  * increment any statement indices present in the IR (`GotoNode`s, `SSAValue`s, etc.) by `statement_offset`

(useful when the caller plans to prepend new statements to the IR)

  * turn off boundschecking (if `boundscheck === :off`) or propagate boundschecking (if `boundscheck === :propagate`)

This function is similar to `Core.Compiler.ssa_substitute!`, but works on pre-type-inference IR instead of the optimizer's IR.
