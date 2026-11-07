```julia
Base.return_types(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::NativeInterpreter=Core.Compiler.NativeInterpreter(world)) -> rts::Vector{Any}
```

Return a list of possible return types for a given function `f` and argument types `types`. The list corresponds to the results of type inference on all the possible method match candidates for `f` and `types` (see also [`methods(f, types)`](@ref methods).

# Arguments

  * `f`: The function to analyze.
  * `types` (optional): The argument types of the function. Defaults to the default tuple type of `f`.
  * `world` (optional): The world counter to use for the analysis. Defaults to the current world counter.
  * `interp` (optional): The abstract interpreter to use for the analysis. Defaults to a new `Core.Compiler.NativeInterpreter` with the specified `world`.

# Returns

  * `rts::Vector{Any}`: The list of return types that are figured out by inference on methods matching with the given `f` and `types`. The list's order matches the order returned by `methods(f, types)`.

# Examples

```julia
julia> Base.return_types(sum, Tuple{Vector{Int}})
1-element Vector{Any}:
 Int64

julia> methods(sum, (Union{Vector{Int},UnitRange{Int}},))
# 2 methods for generic function "sum" from Base:
 [1] sum(r::AbstractRange{<:Real})
     @ range.jl:1399
 [2] sum(a::AbstractArray; dims, kw...)
     @ reducedim.jl:1010

julia> Base.return_types(sum, (Union{Vector{Int},UnitRange{Int}},))
2-element Vector{Any}:
 Int64 # the result of inference on sum(r::AbstractRange{<:Real})
 Int64 # the result of inference on sum(a::AbstractArray; dims, kw...)
```

!!! warning
    The `Base.return_types` function should not be used from generated functions; doing so will result in an error.

