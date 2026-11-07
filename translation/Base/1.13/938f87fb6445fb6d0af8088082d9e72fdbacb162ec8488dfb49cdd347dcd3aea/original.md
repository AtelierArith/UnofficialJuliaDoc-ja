```julia
Base.infer_return_type(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> rt::Type
```

Returns an inferred return type of the function call specified by `f` and `types`.

# Arguments

  * `f`: The function to analyze.
  * `types` (optional): The argument types of the function. Defaults to the default tuple type of `f`.
  * `world` (optional): The world counter to use for the analysis. Defaults to the current world counter.
  * `interp` (optional): The abstract interpreter to use for the analysis. Defaults to a new `Core.Compiler.NativeInterpreter` with the specified `world`.

# Returns

  * `rt::Type`: An inferred return type of the function call specified by the given call signature.

!!! note
    Note that, different from [`Base.return_types`](@ref), this doesn't give you the list return types of every possible method matching with the given `f` and `types`. It returns a single return type, taking into account all potential outcomes of any function call entailed by the given signature type.


# Examples

```julia
julia> checksym(::Symbol) = :symbol;

julia> checksym(x::Any) = x;

julia> Base.infer_return_type(checksym, (Union{Symbol,String},))
Union{String, Symbol}

julia> Base.return_types(checksym, (Union{Symbol,String},))
2-element Vector{Any}:
 Symbol
 Union{String, Symbol}
```

It's important to note the difference here: `Base.return_types` gives back inferred results for each method that matches the given signature `checksum(::Union{Symbol,String})`. On the other hand `Base.infer_return_type` returns one collective result that sums up all those possibilities.

!!! warning
    The `Base.infer_return_type` function should not be used from generated functions; doing so will result in an error.

