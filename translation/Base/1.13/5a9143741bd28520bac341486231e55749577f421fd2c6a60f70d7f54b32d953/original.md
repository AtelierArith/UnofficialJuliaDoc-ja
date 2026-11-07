```julia
code_ircode(f, [types])
```

Return an array of pairs of `IRCode` and inferred return type if type inference succeeds. The `Method` is included instead of `IRCode` otherwise.

See also: [`code_typed`](@ref)

# Internal Keyword Arguments

This section should be considered internal, and is only for who understands Julia compiler internals.

  * `world::UInt = Base.get_world_counter()`: optional, controls the world age to use when looking up methods, use current world age if not specified.
  * `interp::Core.Compiler.AbstractInterpreter = Core.Compiler.NativeInterpreter(world)`: optional, controls the abstract interpreter to use, use the native interpreter if not specified.
  * `optimize_until::Union{Int,String,Nothing} = nothing`: optional, controls the optimization passes to run. If it is a string, it specifies the name of the pass up to which the optimizer is run. If it is an integer, it specifies the number of passes to run. If it is `nothing` (default), all passes are run.

# Examples

One can put the argument types in a tuple to get the corresponding `code_ircode`.

```julia
julia> Base.code_ircode(+, (Float64, Int64))
1-element Vector{Any}:
 388 1 ─ %1 = Base.sitofp(Float64, _3)::Float64
    │   %2 = Base.add_float(_2, %1)::Float64
    └──      return %2
     => Float64

julia> Base.code_ircode(+, (Float64, Int64); optimize_until = "compact 1")
1-element Vector{Any}:
 388 1 ─ %1 = Base.promote(_2, _3)::Tuple{Float64, Float64}
    │   %2 = Core._apply_iterate(Base.iterate, Base.:+, %1)::Float64
    └──      return %2
     => Float64
```
