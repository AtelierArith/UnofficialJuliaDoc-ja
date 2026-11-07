```julia
info::InvokeCallInfo
```

Represents a resolved call to `Core.invoke`, carrying the `info.match::MethodMatch` of the method that has been processed. Optionally keeps `info.result::InferenceResult` that keeps constant information.
