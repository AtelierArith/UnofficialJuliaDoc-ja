```julia
Base.infer_exception_type(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> exct::Type
```

Returns the type of exception potentially thrown by the function call specified by `f` and `types`.

# Arguments

  * `f`: The function to analyze.
  * `types` (optional): The argument types of the function. Defaults to the default tuple type of `f`.
  * `world` (optional): The world counter to use for the analysis. Defaults to the current world counter.
  * `interp` (optional): The abstract interpreter to use for the analysis. Defaults to a new `Core.Compiler.NativeInterpreter` with the specified `world`.

# Returns

  * `exct::Type`: The inferred type of exception that can be thrown by the function call specified by the given call signature.

!!! note
    Note that, different from [`Base.infer_exception_types`](@ref), this doesn't give you the list exception types for every possible matching method with the given `f` and `types`. It returns a single exception type, taking into account all potential outcomes of any function call entailed by the given signature type.


# Examples

```julia
julia> f1(x) = x * 2;

julia> Base.infer_exception_type(f1, (Int,))
Union{}
```

The exception inferred as `Union{}` indicates that `f1(::Int)` will not throw any exception.

```julia
julia> f2(x::Int) = x * 2;

julia> Base.infer_exception_type(f2, (Integer,))
MethodError
```

This case is pretty much the same as with `f1`, but there's a key difference to note. For `f2`, the argument type is limited to `Int`, while the argument type is given as `Tuple{Integer}`. Because of this, taking into account the chance of the method error entailed by the call signature, the exception type is widened to `MethodError`.

!!! warning
    The `Base.infer_exception_type` function should not be used from generated functions; doing so will result in an error.

