```julia
info::ApplyCallInfo <: CallInfo
```

This info applies to any call of `_apply_iterate(...)` and captures both the info of the actual call being applied and the info for any implicit call to the `iterate` function. Note that it is possible for the call itself to be yet another `_apply_iterate`, in which case the `info.call` field will be another `ApplyCallInfo`. This info is illegal on any statement that is not an `_apply_iterate` call.
