```julia
@boundscheck(blk)
```

Annotates the expression `blk` as a bounds checking block, allowing it to be elided by [`@inbounds`](@ref).

!!! note
    The function in which `@boundscheck` is written must be inlined into its caller in order for `@inbounds` to have effect.


# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> @inline function g(A, i)
           @boundscheck checkbounds(A, i)
           return "accessing ($A)[$i]"
       end;

julia> f1() = return g(1:2, -1);

julia> f2() = @inbounds return g(1:2, -1);

julia> f1()
ERROR: BoundsError: attempt to access 2-element UnitRange{Int64} at index [-1]
Stacktrace:
 [1] throw_boundserror(::UnitRange{Int64}, ::Tuple{Int64}) at ./abstractarray.jl:455
 [2] checkbounds at ./abstractarray.jl:420 [inlined]
 [3] g at ./none:2 [inlined]
 [4] f1() at ./none:1
 [5] top-level scope

julia> f2()
"accessing (1:2)[-1]"
```

!!! warning
    The `@boundscheck` annotation allows you, as a library writer, to opt-in to allowing *other code* to remove your bounds checks with [`@inbounds`](@ref). As noted there, the caller must verify—using information they can access—that their accesses are valid before using `@inbounds`. For indexing into your [`AbstractArray`](@ref) subclasses, for example, this involves checking the indices against its [`axes`](@ref). Therefore, `@boundscheck` annotations should only be added to a [`getindex`](@ref) or [`setindex!`](@ref) implementation after you are certain its behavior is correct.

