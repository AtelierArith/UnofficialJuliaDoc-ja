```julia
code_typed(f, types; kw...)
```

Returns an array of type-inferred lowered form (IR) for the methods matching the given generic function and type signature.

# Keyword Arguments

  * `optimize::Bool = true`: optional, controls whether additional optimizations, such as inlining, are also applied.
  * `debuginfo::Symbol = :default`: optional, controls the amount of code metadata present in the output, possible options are `:source` or `:none`.

# Internal Keyword Arguments

This section should be considered internal, and is only for who understands Julia compiler internals.

  * `world::UInt = Base.get_world_counter()`: optional, controls the world age to use when looking up methods, use current world age if not specified.
  * `interp::Core.Compiler.AbstractInterpreter = Core.Compiler.NativeInterpreter(world)`: optional, controls the abstract interpreter to use, use the native interpreter if not specified.

# Examples

One can put the argument types in a tuple to get the corresponding `code_typed`.

```julia
julia> code_typed(+, (Float64, Float64))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Base.add_float(x, y)::Float64
└──      return %1
) => Float64

julia> code_typed((typeof(-), Float64, Float64))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Base.sub_float(x, y)::Float64
└──      return %1
) => Float64

julia> code_typed((Type{Int}, UInt8))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Core.zext_int(Core.Int64, x)::Int64
└──      return %1
) => Int64

julia> code_typed((Returns{Int64},))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 =   builtin Base.getfield(obj, :value)::Int64
└──      return %1
) => Int64
```
