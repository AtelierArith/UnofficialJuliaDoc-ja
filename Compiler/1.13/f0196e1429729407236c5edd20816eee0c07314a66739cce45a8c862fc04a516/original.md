```julia
info::OpaqueClosureCreateInfo <: CallInfo
```

This info may be constructed upon opaque closure construction, with `info.unspec::CallMeta` carrying out inference result of an unreal, partially specialized call (i.e. specialized on the closure environment, but not on the argument types of the opaque closure) in order to allow the optimizer to rewrite the return type parameter of the `OpaqueClosure` based on it.
