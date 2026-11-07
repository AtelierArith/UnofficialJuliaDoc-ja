```julia
add_remark!(::AbstractInterpreter, sv::InferenceState, remark)
```

Emit an analysis remark during inference for the current line (i.e. `sv.currpc`). These annotations are ignored by default, but can be used by external tooling to annotate inference results.
