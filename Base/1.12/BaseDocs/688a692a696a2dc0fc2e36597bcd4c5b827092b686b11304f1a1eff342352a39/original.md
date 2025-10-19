```julia
Int
```

Sys.WORD_SIZE-bit signed integer type, `Int <: Signed <: Integer <: Real`.

This is the default type of most integer literals and is an alias for either `Int32` or `Int64`, depending on `Sys.WORD_SIZE`. It is the type returned by functions such as [`length`](@ref), and the standard type for indexing arrays.

Note that integers overflow without warning, thus `typemax(Int) + 1 < 0` and `10^19 < 0`. Overflow can be avoided by using [`BigInt`](@ref). Very large integer literals will use a wider type, for instance `10_000_000_000_000_000_000 isa Int128`.

Integer division is [`div`](@ref) alias `÷`, whereas [`/`](@ref) acting on integers returns [`Float64`](@ref).

See also [`Int64`](@ref), [`widen`](@ref), [`typemax`](@ref), [`bitstring`](@ref).
