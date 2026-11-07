By default `AbstractInterpreter` implements the following inference bail out logic:

  * `bail_out_toplevel_call(::AbstractInterpreter, sig, ::InferenceState)`: bail out from  inter-procedural inference when inferring top-level and non-concrete call site `callsig`
  * `bail_out_call(::AbstractInterpreter, rt, ::InferenceState)`: bail out from inter-procedural  inference when return type `rt` grows up to `Any`
  * `bail_out_apply(::AbstractInterpreter, rt, ::InferenceState)`: bail out from `_apply_iterate` inference when return type `rt` grows up to `Any`

It also bails out from local statement/frame inference when any lattice element gets down to `Bottom`, but `AbstractInterpreter` doesn't provide a specific interface for configuring it.
