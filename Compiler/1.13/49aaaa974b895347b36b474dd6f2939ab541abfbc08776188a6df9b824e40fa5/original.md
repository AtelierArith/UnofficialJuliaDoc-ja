```julia
AbstractInterpreter
```

An abstract base class that allows multiple dispatch to determine the method of executing Julia code. The native Julia-LLVM pipeline is enabled by using the `NativeInterpreter` concrete instantiation of this abstract class, others can be swapped in as long as they follow the `AbstractInterpreter` API.

If `interp::NewInterpreter` is an `AbstractInterpreter`, it is expected to provide at least the following methods to satisfy the `AbstractInterpreter` API requirement:

  * `InferenceParams(interp::NewInterpreter)` - return an `InferenceParams` instance
  * `OptimizationParams(interp::NewInterpreter)` - return an `OptimizationParams` instance
  * `get_inference_world(interp::NewInterpreter)` - return the world age for this interpreter
  * `get_inference_cache(interp::NewInterpreter)` - return the local inference cache
  * `cache_owner(interp::NewInterpreter)` - return the owner of any new cache entries

If `CodeInstance`s compiled using `interp::NewInterpreter` are meant to be executed with `invoke`, a method `codegen_cache(interp::NewInterpreter) -> IdDict{CodeInstance, CodeInfo}` must be defined, and inference must be triggered via `typeinf_ext_toplevel` with source mode `SOURCE_MODE_ABI`.
