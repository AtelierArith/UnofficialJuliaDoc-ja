```julia
info::OpaqueClosureCallInfo
```

Represents a resolved call of opaque closure, carrying the `info.match::MethodMatch` of the method that has been processed. Optionally keeps `info.result::InferenceResult` that keeps constant information.
