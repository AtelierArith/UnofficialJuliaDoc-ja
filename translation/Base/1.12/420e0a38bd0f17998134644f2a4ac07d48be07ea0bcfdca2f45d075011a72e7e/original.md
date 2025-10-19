```julia
@world(sym, world)
```

Resolve the binding `sym` in world `world`. See [`invoke_in_world`](@ref) for running arbitrary code in fixed worlds. `world` may be `UnitRange`, in which case the macro will error unless the binding is valid and has the same value across the entire world range.

As a special case, the world `∞` always refers to the latest world, even if that world is newer than the world currently running.

The `@world` macro is primarily used in the printing of bindings that are no longer available in the current world.

## Example

```julia-repl
julia> struct Foo; a::Int; end
Foo

julia> fold = Foo(1)

julia> Int(Base.get_world_counter())
26866

julia> struct Foo; a::Int; b::Int end
Foo

julia> fold
@world(Foo, 26866)(1)
```

!!! compat "Julia 1.12"
    This functionality requires at least Julia 1.12.

