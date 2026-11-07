```julia
Base.infer_exception_types(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::NativeInterpreter=Core.Compiler.NativeInterpreter(world)) -> excts::Vector{Any}
```

Return a list of possible exception types for a given function `f` and argument types `types`. The list corresponds to the results of type inference on all the possible method match candidates for `f` and `types` (see also [`methods(f, types)`](@ref methods). It works like [`Base.return_types`](@ref), but it infers the exception types instead of the return types.

# Arguments

  * `f`: The function to analyze.
  * `types` (optional): The argument types of the function. Defaults to the default tuple type of `f`.
  * `world` (optional): The world counter to use for the analysis. Defaults to the current world counter.
  * `interp` (optional): The abstract interpreter to use for the analysis. Defaults to a new `Core.Compiler.NativeInterpreter` with the specified `world`.

# Returns

  * `excts::Vector{Any}`: The list of exception types that are figured out by inference on methods matching with the given `f` and `types`. The list's order matches the order returned by `methods(f, types)`.

# Examples

```julia
julia> throw_if_number(::Number) = error("number is given");

julia> throw_if_number(::Any) = nothing;

julia> Base.infer_exception_types(throw_if_number, (Int,))
1-element Vector{Any}:
 ErrorException

julia> methods(throw_if_number, (Any,))
# 2 methods for generic function "throw_if_number" from Main:
 [1] throw_if_number(x::Number)
     @ REPL[1]:1
 [2] throw_if_number(::Any)
     @ REPL[2]:1

julia> Base.infer_exception_types(throw_if_number, (Any,))
2-element Vector{Any}:
 ErrorException # the result of inference on `throw_if_number(::Number)`
 Union{}        # the result of inference on `throw_if_number(::Any)`
```

!!! warning
    The `Base.infer_exception_types` function should not be used from generated functions; doing so will result in an error.

