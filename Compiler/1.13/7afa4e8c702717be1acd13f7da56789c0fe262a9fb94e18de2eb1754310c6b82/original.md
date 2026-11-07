```julia
info::UnionSplitApplyCallInfo <: CallInfo
```

Like `UnionSplitInfo`, but for `ApplyCallInfo` rather than `MethodMatchInfo`. This info is illegal on any statement that is not an `_apply_iterate` call.
