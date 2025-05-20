```
Base.infer_effects(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> effects::Effects
```

Returns the possible computation effects of the function call specified by `f` and `types`.

# Arguments

  * `f`: The function to analyze.
  * `types` (optional): The argument types of the function. Defaults to the default tuple type of `f`.
  * `world` (optional): The world counter to use for the analysis. Defaults to the current world counter.
  * `interp` (optional): The abstract interpreter to use for the analysis. Defaults to a new `Core.Compiler.NativeInterpreter` with the specified `world`.

# Returns

  * `effects::Effects`: The computed effects of the function call specified by the given call signature. See the documentation of [`Effects`](@ref Core.Compiler.Effects) or [`Base.@assume_effects`](@ref) for more information on the various effect properties.

!!! note
    Note that, different from [`Base.return_types`](@ref), this doesn't give you the list effect analysis results for every possible matching method with the given `f` and `types`. It returns a single effect, taking into account all potential outcomes of any function call entailed by the given signature type.


# Examples

```julia
julia> f1(x) = x * 2;

julia> Base.infer_effects(f1, (Int,))
(+c,+e,+n,+t,+s,+m,+i)
```

This function will return an `Effects` object with information about the computational effects of the function `f1` when called with an `Int` argument.

```julia
julia> f2(x::Int) = x * 2;

julia> Base.infer_effects(f2, (Integer,))
(+c,+e,!n,+t,+s,+m,+i)
```

This case is pretty much the same as with `f1`, but there's a key difference to note. For `f2`, the argument type is limited to `Int`, while the argument type is given as `Tuple{Integer}`. Because of this, taking into account the chance of the method error entailed by the call signature, the `:nothrow` bit gets tainted.

!!! warning
    The `Base.infer_effects` function should not be used from generated functions; doing so will result in an error.


# See Also

  * [`Core.Compiler.Effects`](@ref): A type representing the computational effects of a method call.
  * [`Base.@assume_effects`](@ref): A macro for making assumptions about the effects of a method.
